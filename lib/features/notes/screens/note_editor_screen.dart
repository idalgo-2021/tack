import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/note.dart';
import '../../../data/models/tag.dart';
import '../../../data/repositories/note_repository.dart';
import '../../../data/repositories/tag_repository.dart';
import '../widgets/note_text_field.dart';
import '../../media/widgets/audio_player_widget.dart';
import '../../media/widgets/image_grid_widget.dart';
import '../../media/providers/media_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../../tags/providers/tag_provider.dart';
import '../providers/note_list_provider.dart';
import '../widgets/note_action_buttons.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final Note? existingNote;

  const NoteEditorScreen({super.key, this.existingNote});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  late final TextEditingController _searchController;
  late final TextEditingController _createController;
  bool _hasChanges = false;
  List<String> _imagePaths = [];
  List<String> _audioPaths = [];
  List<String> _filePaths = [];
  List<String> _tagNames = [];
  double? _latitude;
  double? _longitude;
  int? _savedNoteId;
  Timer? _saveTimer;

  Note? get _existingNote => widget.existingNote;

  bool get _hasUnsavedChanges => _hasChanges;

  bool get hasLocation => _latitude != null && _longitude != null;

  bool get _isEmptyNote =>
      _textController.text.trim().isEmpty &&
      _tagNames.isEmpty &&
      _imagePaths.isEmpty &&
      _audioPaths.isEmpty &&
      _filePaths.isEmpty &&
      !hasLocation;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _existingNote?.text ?? '');
    _focusNode = FocusNode();
    _searchController = TextEditingController();
    _createController = TextEditingController();
    _filePaths = List.from(_existingNote?.filePaths ?? []);
    _imagePaths = List.from(_existingNote?.imagePaths ?? []);
    _audioPaths = List.from(_existingNote?.audioPaths ?? []);
    _tagNames = List.from(_existingNote?.tags ?? []);
    _latitude = _existingNote?.latitude;
    _longitude = _existingNote?.longitude;

    _textController.addListener(_onFieldChanged);

    if (_existingNote == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onFieldChanged);
    _saveTimer?.cancel();
    _textController.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    _createController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
    final autoSave = ref.read(autoSaveProvider);
    if (autoSave) _scheduleAutoSave();
  }

  void _scheduleAutoSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), _saveNote);
  }

  Future<void> _saveNote() async {
    final autoSave = ref.read(autoSaveProvider);
    final now = DateTime.now();

    if (autoSave && _isEmptyNote) {
      if (mounted) setState(() => _hasChanges = false);
      return;
    }

    final noteId = _existingNote?.id ?? _savedNoteId;
    final note = Note(
      id: noteId,
      text: _textController.text.trim().isEmpty ? null : _textController.text.trim(),
      tags: _tagNames,
      imagePaths: [
        ...?_existingNote?.imagePaths,
        ..._imagePaths,
      ],
      audioPaths: [
        ...?_existingNote?.audioPaths,
        ..._audioPaths,
      ],
      filePaths: _filePaths,
      createdAt: _existingNote?.createdAt ?? now,
      latitude: _latitude,
      longitude: _longitude,
    );

    final repo = NoteRepository();
    if (noteId != null) {
      await repo.update(note);
    } else {
      final id = await repo.insert(note);
      _savedNoteId = id;
    }

    ref.invalidate(noteListProvider);
    ref.invalidate(tagListProvider);

    if (mounted && autoSave) {
      setState(() => _hasChanges = false);
    }
  }

  Future<void> _showTagSelector() async {
    ref.invalidate(tagListProvider);
    final repo = TagRepository();
    final allTags = await repo.getAll();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => _TagSelectorDialog(
        allTags: allTags,
        initialSelected: _tagNames,
        l10n: AppLocalizations.of(context),
        onApply: (selected) {
          setState(() {
            _tagNames = selected;
            _hasChanges = true;
          });
          final autoSave = ref.read(autoSaveProvider);
          if (autoSave) _scheduleAutoSave();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final autoSave = ref.watch(autoSaveProvider);
    final isRecording = ref.watch(mediaRecorderProvider);
    final showTs = ref.watch(showTimestampProvider);

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (!autoSave && _hasChanges) {
          if (!_isEmptyNote) {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(l10n.saveChanges),
                content: Text(l10n.emptyNoteConfirm),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(l10n.discard),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(l10n.save),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              await _saveNote();
            }
          } else if (mounted) {
            setState(() => _hasChanges = false);
          }
        } else if (autoSave && _hasChanges) {
          await _saveNote();
        }
        if (mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_existingNote != null ? l10n.editNote : l10n.newNote),
          actions: [
            if (!autoSave)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilledButton(
                  onPressed: _hasChanges ? _saveNote : null,
                  child: Text(l10n.save),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showTs || hasLocation) ...[
                Row(
                  children: [
                    if (showTs) ...[
                      Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        DateFormatter.formatAbsoluteWithWeekday(
                          _existingNote?.createdAt ?? DateTime.now(),
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (showTs && hasLocation) const SizedBox(width: 16),
                    if (hasLocation) ...[
                      Icon(Icons.location_on, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDMS(_latitude!, _longitude!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  ..._tagNames.map((name) => Chip(
                    label: Text('#$name', style: const TextStyle(fontSize: 12)),
                    onDeleted: () {
                      setState(() {
                        _tagNames.remove(name);
                        _hasChanges = true;
                      });
                      if (autoSave) _scheduleAutoSave();
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )),
                  ActionChip(
                    label: Text(l10n.selectTags, style: const TextStyle(fontSize: 12)),
                    avatar: const Icon(Icons.add, size: 16),
                    onPressed: _showTagSelector,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              NoteTextField(
                controller: _textController,
                focusNode: _focusNode,
                hintText: l10n.startWriting,
              ),
              if (_imagePaths.isNotEmpty) ...[
                const SizedBox(height: 16),
                ImageGridWidget(
                  imagePaths: _imagePaths,
                  onDelete: (path) {
                    setState(() {
                      _imagePaths.remove(path);
                      _hasChanges = true;
                    });
                    if (autoSave) _scheduleAutoSave();
                  },
                ),
              ],
              if (_audioPaths.isNotEmpty) ...[
                ..._audioPaths.map((audioPath) => Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.audio, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      AudioPlayerWidget(
                        audioPath: audioPath,
                        onDelete: () {
                          setState(() {
                            _audioPaths.remove(audioPath);
                            _hasChanges = true;
                          });
                          if (autoSave) _scheduleAutoSave();
                        },
                      ),
                    ],
                  ),
                )),
              ],
              if (_filePaths.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l10n.files, style: theme.textTheme.titleSmall),
                ..._filePaths.map((path) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(path.split('/').last),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _filePaths.remove(path);
                          _hasChanges = true;
                        });
                        if (autoSave) _scheduleAutoSave();
                      },
                    ),
                  ),
                )),
              ],
              if (isRecording) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.mic, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(l10n.recording, style: const TextStyle(color: Colors.red)),
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomSheet: NoteActionButtons(
          hasLocation: hasLocation,
          onImageAdded: (path) {
            setState(() {
              _imagePaths.add(path);
              _hasChanges = true;
            });
          },
          onAudioAdded: (path) {
            setState(() {
              _audioPaths.add(path);
              _hasChanges = true;
            });
          },
          onFileAdded: (path) {
            setState(() {
              _filePaths.add(path);
              _hasChanges = true;
            });
          },
          onLatitudeChanged: (lat) {
            setState(() {
              _latitude = lat;
              _hasChanges = true;
            });
          },
          onLongitudeChanged: (lon) {
            setState(() {
              _longitude = lon;
              _hasChanges = true;
            });
          },
          onLocationCleared: () {
            setState(() {
              _latitude = null;
              _longitude = null;
              _hasChanges = true;
            });
          },
        ),
      ),
    );
  }
}

class _TagSelectorDialog extends StatefulWidget {
  final List<Tag> allTags;
  final List<String> initialSelected;
  final AppLocalizations l10n;
  final ValueChanged<List<String>> onApply;

  const _TagSelectorDialog({
    required this.allTags,
    required this.initialSelected,
    required this.l10n,
    required this.onApply,
  });

  @override
  State<_TagSelectorDialog> createState() => _TagSelectorDialogState();
}

class _TagSelectorDialogState extends State<_TagSelectorDialog> {
  late List<Tag> _allTags;
  late Set<String> _selected;
  final _searchController = TextEditingController();
  final _createController = TextEditingController();
  final _createFocusNode = FocusNode();
  String _searchQuery = '';

  List<Tag> get _filteredTags {
    if (_searchQuery.isEmpty) return _allTags;
    return _allTags
        .where((t) => t.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _allTags = List.from(widget.allTags);
    _selected = widget.initialSelected.toSet();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _createController.dispose();
    _createFocusNode.dispose();
    super.dispose();
  }

  Future<void> _createTag() async {
    final name = _createController.text.trim();
    if (name.isEmpty || _selected.contains(name)) return;

    if (_allTags.any((t) => t.name == name)) {
      setState(() => _selected.add(name));
    } else {
      await ProviderScope.containerOf(context).read(tagListProvider.notifier).add(name);
      if (!mounted) return;
      setState(() {
        _allTags.add(Tag(name: name, usageCount: 0));
        _selected.add(name);
      });
    }

    _createController.clear();
    _createFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = widget.l10n;
    final filtered = _filteredTags;

    return AlertDialog(
      title: Text(l10n.selectTags),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchTags,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 12),
            if (_selected.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _selected.map((name) => Chip(
                  label: Text('#$name', style: const TextStyle(fontSize: 12)),
                  onDeleted: () => setState(() => _selected.remove(name)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _selected.clear()),
                child: Text(l10n.clearAll),
              ),
              const Divider(),
            ],
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _createController,
                    focusNode: _createFocusNode,
                    decoration: InputDecoration(
                      hintText: l10n.addTag,
                      prefixText: '# ',
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => _createTag(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _createTag,
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: filtered.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isNotEmpty ? l10n.noTagsForQuery : l10n.noTags,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView(
                    children: filtered.map((tag) {
                      final isSelected = _selected.contains(tag.name);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => setState(() {
                            if (isSelected) {
                              _selected.remove(tag.name);
                            } else {
                              _selected.add(tag.name);
                            }
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                ? theme.colorScheme.primaryContainer
                                : null,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                  size: 20,
                                  color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '#${tag.name}',
                                  style: TextStyle(
                                    fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${tag.usageCount}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            widget.onApply(_selected.toList());
            Navigator.pop(context);
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}
