import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/file_utils.dart';
import '../../../data/models/note.dart';
import '../../../core/providers/repository_providers.dart';
import '../../settings/providers/settings_provider.dart';
import '../../tags/providers/tag_provider.dart';
import '../../tags/widgets/tag_selector_dialog.dart';
import '../providers/note_list_provider.dart';

abstract class NoteEditorState<T extends ConsumerStatefulWidget> extends ConsumerState<T> {
  late final TextEditingController textController;
  late final FocusNode focusNode;
  bool hasChanges = false;
  List<String> imagePaths = [];
  List<String> audioPaths = [];
  List<String> filePaths = [];
  List<String> videoPaths = [];
  List<String> tagNames = [];
  double? latitude;
  double? longitude;
  int? savedNoteId;
  Timer? saveTimer;

  final Set<String> newFilePaths = {};
  final Set<String> deletedFilePaths = {};

  bool get hasLocation => latitude != null && longitude != null;

  List<String> get cameraPaths {
    final result = [
      ...imagePaths.where(FileUtils.isCameraFile),
      ...videoPaths.where(FileUtils.isCameraFile),
    ];
    return result.reversed.toList();
  }

  List<String> get allFilePaths {
    final result = [
      ...imagePaths.where((p) => !FileUtils.isCameraFile(p)),
      ...videoPaths.where((p) => !FileUtils.isCameraFile(p)),
      ...filePaths,
    ];
    try {
      result.sort((a, b) => File(b).lastModifiedSync().compareTo(File(a).lastModifiedSync()));
    } catch (_) {}
    return result;
  }

  List<String> get allPreviewPaths => [...cameraPaths, ...allFilePaths];

  bool get isEmptyNote =>
      textController.text.trim().isEmpty &&
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

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    focusNode = FocusNode();
    textController.addListener(handleFieldChanged);
  }

  @override
  void dispose() {
    textController.removeListener(handleFieldChanged);
    saveTimer?.cancel();
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @protected
  void handleFieldChanged() {
    if (!hasChanges) {
      setState(() => hasChanges = true);
    }
    final autoSave = ref.read(autoSaveProvider);
    if (autoSave) scheduleAutoSave();
  }

  void scheduleAutoSave() {
    saveTimer?.cancel();
    saveTimer = Timer(const Duration(seconds: 2), saveNote);
  }

  void handleFileRemoved(String path) {
    if (newFilePaths.contains(path)) {
      newFilePaths.remove(path);
      FileUtils.deleteFile(path);
    } else {
      deletedFilePaths.add(path);
    }
  }

  Future<void> saveNote() async {
    if (!hasChanges && noteIdForSave != null) return;
    if (isEmptyNote) {
      if (mounted) setState(() => hasChanges = false);
      return;
    }
    try {
      final id = noteIdForSave;
      final note = Note(
        id: id,
        text: textController.text.trim().isEmpty ? null : textController.text.trim(),
        tags: tagNames,
        imagePaths: imagePaths,
        audioPaths: audioPaths,
        filePaths: filePaths,
        videoPaths: videoPaths,
        createdAt: effectiveCreatedAt,
        latitude: latitude,
        longitude: longitude,
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context).error}: $e')),
        );
      }
      return;
    }

    await FileUtils.deleteFiles(deletedFilePaths.toList());
    newFilePaths.clear();
    deletedFilePaths.clear();
    if (mounted) {
      setState(() => hasChanges = false);
    }
  }

  Future<void> showTagSelector() async {
    ref.invalidate(tagListProvider);
    final repo = ref.read(tagRepositoryProvider);
    final allTags = await repo.getAll();
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
