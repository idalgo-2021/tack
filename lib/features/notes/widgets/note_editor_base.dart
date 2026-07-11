import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/file_utils.dart';
import '../../../core/utils/keyboard_utils.dart';
import '../../../data/models/note.dart';
import '../../../core/providers/repository_providers.dart';
import '../../settings/providers/settings_provider.dart';
import '../../tags/providers/tag_provider.dart';
import '../../tags/widgets/tag_selector_dialog.dart';
import '../providers/note_list_provider.dart';
import '../../media/providers/media_provider.dart';

List<String> _sortByLastModified(List<String> paths) {
  paths.sort(
    (a, b) => File(b).lastModifiedSync().compareTo(File(a).lastModifiedSync()),
  );
  return paths;
}

abstract class NoteEditorState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  late QuillController quillController;
  late final FocusNode focusNode;
  bool showFormattingToolbar = false;
  bool hasChanges = false;
  List<String> imagePaths = [];
  List<String> audioPaths = [];
  List<String> filePaths = [];
  List<String> videoPaths = [];
  List<String> tagNames = [];
  double? latitude;
  double? longitude;
  int? noteColor;
  bool isPinned = false;
  DateTime updatedAt = DateTime.now();
  int? savedNoteId;
  bool _hasSavedOnce = false;
  Timer? saveTimer;

  final Set<String> newFilePaths = {};
  final Set<String> deletedFilePaths = {};

  bool _isSaving = false;
  int _changeVersion = 0;

  List<String>? _cachedAllFilePaths;
  bool _filePathsCacheValid = false;

  bool get hasLocation => latitude != null && longitude != null;

  List<String> get cameraPaths {
    final result = [
      ...imagePaths.where(FileUtils.isCameraFile),
      ...videoPaths.where(FileUtils.isCameraFile),
    ];
    return result.reversed.toList();
  }

  List<String> get allFilePaths {
    if (!_filePathsCacheValid) {
      _rebuildFilePathsCache();
    }
    return _cachedAllFilePaths ?? _unsortedAllFilePaths;
  }

  List<String> get _unsortedAllFilePaths {
    return [
      ...imagePaths.where((p) => !FileUtils.isCameraFile(p)),
      ...videoPaths.where((p) => !FileUtils.isCameraFile(p)),
      ...filePaths,
    ];
  }

  Future<void> _rebuildFilePathsCache() async {
    final unsorted = _unsortedAllFilePaths;
    if (unsorted.isEmpty) {
      _cachedAllFilePaths = [];
      _filePathsCacheValid = true;
      return;
    }
    try {
      final sorted = await compute(_sortByLastModified, unsorted);
      _cachedAllFilePaths = sorted;
    } catch (_) {
      _cachedAllFilePaths = unsorted;
    }
    _filePathsCacheValid = true;
  }

  void _invalidateFilePathsCache() {
    _filePathsCacheValid = false;
    _cachedAllFilePaths = null;
  }

  List<String> get allPreviewPaths => [...cameraPaths, ...allFilePaths];

  bool get isEmptyNote =>
      quillController.document.toPlainText().trim().isEmpty &&
      tagNames.isEmpty &&
      imagePaths.isEmpty &&
      audioPaths.isEmpty &&
      filePaths.isEmpty &&
      videoPaths.isEmpty &&
      !hasLocation;

  @protected
  int? get noteIdForSave;

  @protected
  DateTime get effectiveCreatedAt;

  @protected
  void onNoteSaved(int? noteId) {}

  void toggleFormattingToolbar() {
    setState(() {
      showFormattingToolbar = !showFormattingToolbar;
      quillController.readOnly = showFormattingToolbar;
    });
    if (showFormattingToolbar) {
      SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide');
    }
  }

  @override
  void initState() {
    super.initState();
    quillController = QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
    focusNode = FocusNode();
    quillController.addListener(handleFieldChanged);
    KeyboardUtils.configureTabletKeyboard();
    focusNode.addListener(() {
      if (focusNode.hasFocus) KeyboardUtils.configureTabletKeyboard();
    });
  }

  @protected
  void initQuillController(Document document) {
    quillController.removeListener(handleFieldChanged);
    quillController.dispose();
    quillController = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
    quillController.addListener(handleFieldChanged);
    KeyboardUtils.configureTabletKeyboard();
  }

  @override
  void dispose() {
    if (ref.read(mediaRecorderProvider)) {
      ref.read(mediaRecorderProvider.notifier).cancelRecording();
    }
    quillController.removeListener(handleFieldChanged);
    saveTimer?.cancel();
    quillController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @protected
  void handleFieldChanged() {
    if (!hasChanges) {
      setState(() => hasChanges = true);
    }
    _changeVersion++;
    final autoSave = ref.read(autoSaveProvider);
    if (autoSave) scheduleAutoSave();
  }

  void scheduleAutoSave() {
    saveTimer?.cancel();
    saveTimer = Timer(const Duration(seconds: 2), saveNote);
  }

  void handleFileRemoved(String path) {
    setState(() {
      if (newFilePaths.contains(path)) {
        newFilePaths.remove(path);
      } else {
        deletedFilePaths.add(path);
      }
      imagePaths.remove(path);
      audioPaths.remove(path);
      filePaths.remove(path);
      videoPaths.remove(path);
      hasChanges = true;
    });
    _changeVersion++;
    _invalidateFilePathsCache();
    final autoSave = ref.read(autoSaveProvider);
    if (autoSave) scheduleAutoSave();
  }

  @protected
  void onFilePathsChanged() {
    _invalidateFilePathsCache();
  }

  Future<void> saveNote({bool updateTimestamp = true}) async {
    if (_isSaving) return;
    if (!hasChanges && noteIdForSave != null) return;

    final hasPendingFileOps =
        deletedFilePaths.isNotEmpty || newFilePaths.isNotEmpty;
    if (isEmptyNote && !hasPendingFileOps) {
      if (mounted) setState(() => hasChanges = false);
      return;
    }

    _isSaving = true;
    final deletedSnapshot = deletedFilePaths.toSet();
    final newSnapshot = newFilePaths.toSet();
    final hasPendingDeletion = deletedSnapshot.isNotEmpty;

    if (noteIdForSave == null && isEmptyNote && !hasPendingDeletion) {
      _isSaving = false;
      if (mounted) setState(() => hasChanges = false);
      return;
    }
    final savedVersion = _changeVersion;
    try {
      final id = noteIdForSave;
      final plainText = quillController.document.toPlainText().trim();
      final note = Note(
        id: id,
        text: plainText.isEmpty
            ? null
            : jsonEncode(quillController.document.toDelta().toJson()),
        tagNames: tagNames,
        imagePaths: imagePaths,
        audioPaths: audioPaths,
        filePaths: filePaths,
        videoPaths: videoPaths,
        createdAt: effectiveCreatedAt,
        updatedAt: id == null
            ? DateTime.now()
            : (updateTimestamp && ref.read(updateTimestampOnEditProvider)
                  ? DateTime.now()
                  : updatedAt),
        latitude: latitude,
        longitude: longitude,
        color: noteColor,
        isPinned: isPinned,
      );

      final repo = ref.read(noteRepositoryProvider);
      if (id != null) {
        await repo.update(note);
      } else {
        savedNoteId = await repo.insert(note);
      }

      ref.invalidate(noteListProvider);
      ref.invalidate(tagListProvider);
      onNoteSaved(savedNoteId ?? id);
    } catch (e) {
      // DB write failed: keep pending deletions/additions for next save attempt.
      _isSaving = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context).error}: $e')),
        );
      }
      return;
    }

    // DB write succeeded: now safe to delete files from disk.
    try {
      await FileUtils.deleteFiles(deletedSnapshot.toList());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context).error}: $e')),
        );
      }
    }
    // Remove only the entries captured in the snapshot; newer ones stay pending.
    deletedFilePaths.removeAll(deletedSnapshot);
    newFilePaths.removeAll(newSnapshot);
    _isSaving = false;
    // If changes occurred during save, keep hasChanges true so the next save runs.
    final changedDuringSave = _changeVersion != savedVersion;
    if (mounted) {
      setState(() => hasChanges = changedDuringSave);
    }
    if (changedDuringSave && ref.read(autoSaveProvider)) {
      scheduleAutoSave();
    }
  }

  Future<bool> confirmSaveForAttachment() async {
    if (ref.read(autoSaveProvider) || _hasSavedOnce) return true;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).saveChanges),
        content: Text(AppLocalizations.of(context).saveBeforeAttach),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context).discard),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context).save),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await saveNote();
      _hasSavedOnce = true;
      return true;
    }
    return false;
  }

  Future<void> showTagSelector() async {
    final allTags = await ref.read(tagListProvider.future);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => TagSelectorDialog(
        allTags: allTags,
        initialSelected: tagNames,
        l10n: AppLocalizations.of(context),
        onCreateTag: (name) => ref.read(tagListProvider.notifier).add(name),
        onApply: (selected) {
          setState(() {
            tagNames = selected;
            hasChanges = true;
          });
          final autoSave = ref.read(autoSaveProvider);
          if (autoSave) scheduleAutoSave();
        },
      ),
    );
  }
}
