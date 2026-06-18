import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/export_helper.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/note.dart';
import '../../../data/models/tag.dart';
import '../../../data/repositories/note_repository.dart';
import '../../../data/repositories/tag_repository.dart';
import '../providers/note_detail_provider.dart';
import '../providers/note_list_provider.dart';
import '../../media/widgets/audio_player_widget.dart';
import '../../media/widgets/image_grid_widget.dart';
import '../../settings/providers/settings_provider.dart';
import '../../tags/providers/tag_provider.dart';
import '../widgets/note_action_buttons.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  final int noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<String> _tags = [];
  List<String> _imagePaths = [];
  List<String> _audioPaths = [];
  List<String> _filePaths = [];
  double? _latitude;
  double? _longitude;
  DateTime? _createdAt;

  bool _initialized = false;
  bool _hasChanges = false;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _saveTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (!_initialized) return;
    _markChanged();
  }

  void _markChanged() {
    if (!_hasChanges && mounted) {
      setState(() => _hasChanges = true);
    }
    if (mounted && ref.read(autoSaveProvider)) {
      _scheduleAutoSave();
    }
  }

  void _scheduleAutoSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), _save);
  }

  void _initFromNote(Note note) {
    _textController.text = note.text ?? '';
    _tags = List.from(note.tags);
    _imagePaths = List.from(note.imagePaths);
    _audioPaths = List.from(note.audioPaths);
    _filePaths = List.from(note.filePaths);
    _latitude = note.latitude;
    _longitude = note.longitude;
    _createdAt = note.createdAt;
    _hasChanges = false;
    _initialized = true;
  }

  Future<void> _save() async {
    if (!_hasChanges) return;
    final updateTs = ref.read(updateTimestampOnEditProvider);
    final note = Note(
      id: widget.noteId,
      text: _textController.text.isEmpty ? null : _textController.text,
      tags: _tags,
      imagePaths: _imagePaths,
      audioPaths: _audioPaths,
      filePaths: _filePaths,
      createdAt: updateTs ? DateTime.now() : (_createdAt ?? DateTime.now()),
      latitude: _latitude,
      longitude: _longitude,
    );
    final repo = NoteRepository();
    await repo.update(note);
    ref.invalidate(noteListProvider);
    ref.invalidate(tagListProvider);
    ref.invalidate(noteDetailProvider(widget.noteId));
    _hasChanges = false;
    _createdAt = note.createdAt;
  }

  Future<void> _showTagSelector() async {
    final l10n = AppLocalizations.of(context);
    ref.invalidate(tagListProvider);
    final repo = TagRepository();
    final allTags = await repo.getAll();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => _TagSelectorDialog(
        allTags: allTags,
        initialSelected: _tags,
        l10n: l10n,
        onApply: (selected) {
          setState(() {
            _tags = selected..sort();
            _hasChanges = true;
          });
          if (ref.read(autoSaveProvider)) _scheduleAutoSave();
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteNote),
        content: Text(l10n.deleteConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed != true) return;
    final repo = NoteRepository();
    await repo.delete(widget.noteId);
    if (context.mounted) {
      ref.invalidate(noteListProvider);
      Navigator.pop(context);
    }
  }

  Future<void> _shareNote(dynamic note) async {
    final format = ref.read(exportFormatProvider);
    final zip = ref.read(zipExportProvider);
    final timestamp = DateFormatter.formatFileDate(note.createdAt);
    final allFiles = <XFile>[];

    if (format == ExportFormat.markdown) {
      final content = ExportHelper.notesToMarkdown([note]);
      final file = File('${Directory.systemTemp.path}/smart_note_$timestamp.md');
      await file.writeAsString(content);
      allFiles.add(XFile(file.path));
    } else {
      final content = ExportHelper.notesToJson([note]);
      final file = File('${Directory.systemTemp.path}/smart_note_$timestamp.json');
      await file.writeAsString(content);
      allFiles.add(XFile(file.path));
    }

    if (zip) {
      final attachPaths = <String>[allFiles.first.path];
      for (final p in note.imagePaths) { attachPaths.add(p); }
      for (final p in note.audioPaths) { attachPaths.add(p); }
      for (final p in note.filePaths) { attachPaths.add(p); }
      final zipPath = '${Directory.systemTemp.path}/smart_note_$timestamp.zip';
      await ExportHelper.createZip(zipPath, attachPaths);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(zipPath)]),
      );
    } else {
      for (final p in note.imagePaths) { allFiles.add(XFile(p)); }
      for (final p in note.audioPaths) { allFiles.add(XFile(p)); }
      for (final p in note.filePaths) { allFiles.add(XFile(p)); }
      await SharePlus.instance.share(
        ShareParams(files: allFiles),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final noteAsync = ref.watch(noteDetailProvider(widget.noteId));
    final showTs = ref.watch(showTimestampProvider);
    final autoSave = ref.watch(autoSaveProvider);
    final theme = Theme.of(context);

    return noteAsync.when(
      data: (note) {
        if (note == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.article_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(l10n.noteNotFound, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(l10n.noteDeleted, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          );
        }

        if (!_initialized) _initFromNote(note);

        final hasLocation = _latitude != null && _longitude != null;

        return PopScope(
          canPop: !_hasChanges,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            if (autoSave) {
              await _save();
              if (context.mounted) Navigator.of(context).pop();
            } else {
              final discard = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.saveChanges),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.discard),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.save),
                    ),
                  ],
                ),
              );
              if (discard == true) {
                if (context.mounted) Navigator.of(context).pop();
              } else {
                await _save();
                if (context.mounted) Navigator.of(context).pop();
              }
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.editNote),
              actions: [
                if (note.text != null && note.text!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _textController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.textCopied)),
                      );
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _shareNote(note),
                ),
                if (!autoSave && _hasChanges)
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _save,
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
            body: GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              behavior: HitTestBehavior.translucent,
              child: Column(
              children: [
                if (_hasChanges)
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: theme.colorScheme.primary,
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (showTs)
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurfaceVariant),
                                  const SizedBox(width: 6),
                                  Text(
                                    DateFormatter.formatAbsoluteWithWeekday(_createdAt ?? note.createdAt),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            if (showTs && hasLocation) const SizedBox(width: 16),
                            if (hasLocation)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on, size: 14, color: theme.colorScheme.onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormatter.formatDMS(_latitude!, _longitude!),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        if (_tags.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              ..._tags.map((tag) => Chip(
                                label: Text('#$tag', style: const TextStyle(fontSize: 12)),
                                onDeleted: () {
                                  setState(() {
                                    _tags.remove(tag);
                                    _hasChanges = true;
                                  });
                                  if (autoSave) _scheduleAutoSave();
                                },
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                deleteIcon: const Icon(Icons.close, size: 16),
                                deleteIconColor: theme.colorScheme.onSurfaceVariant,
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
                        ] else ...[
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _showTagSelector,
                            icon: const Icon(Icons.label, size: 16),
                            label: Text(l10n.selectTag, style: const TextStyle(fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isCollapsed: true,
                            hintText: _textController.text.isEmpty ? l10n.startWriting : null,
                            hintStyle: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
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
                          const SizedBox(height: 16),
                          Text(l10n.audio, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 8),
                          ..._audioPaths.map((path) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: AudioPlayerWidget(
                              audioPath: path,
                              onDelete: () {
                                setState(() {
                                  _audioPaths.remove(path);
                                  _hasChanges = true;
                                });
                                if (autoSave) _scheduleAutoSave();
                              },
                            ),
                          )),
                        ],
                        if (_filePaths.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(l10n.files, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 8),
                          ..._filePaths.map((path) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: ListTile(
                              dense: true,
                              leading: const Icon(Icons.attach_file),
                              title: Text(path.split('/').last, style: const TextStyle(fontSize: 13)),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 18),
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
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
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
                if (autoSave) _scheduleAutoSave();
              },
              onAudioAdded: (path) {
                setState(() {
                  _audioPaths.add(path);
                  _hasChanges = true;
                });
                if (autoSave) _scheduleAutoSave();
              },
              onFileAdded: (path) {
                setState(() {
                  _filePaths.add(path);
                  _hasChanges = true;
                });
                if (autoSave) _scheduleAutoSave();
              },
              onLatitudeChanged: (lat) {
                setState(() {
                  _latitude = lat;
                  _hasChanges = true;
                });
                if (autoSave) _scheduleAutoSave();
              },
              onLongitudeChanged: (lon) {
                setState(() {
                  _longitude = lon;
                  _hasChanges = true;
                });
                if (autoSave) _scheduleAutoSave();
              },
              onLocationCleared: () {
                setState(() {
                  _latitude = null;
                  _longitude = null;
                  _hasChanges = true;
                });
                if (autoSave) _scheduleAutoSave();
              },
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('${l10n.error}: $error')),
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

  @override
  void initState() {
    super.initState();
    _allTags = List.from(widget.allTags);
    _selected = Set<String>.from(widget.initialSelected);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _createController.dispose();
    _createFocusNode.dispose();
    super.dispose();
  }

  Future<void> _createTag() async {
    final name = _createController.text.trim().toLowerCase();
    if (name.isEmpty || _selected.contains(name)) return;

    if (_allTags.any((t) => t.name == name)) {
      setState(() {
        _selected.add(name);
        _searchQuery = '';
        _searchController.clear();
      });
    } else {
      await ProviderScope.containerOf(context).read(tagListProvider.notifier).add(name);
      if (!mounted) return;
      setState(() {
        _allTags.add(Tag(name: name, usageCount: 0));
        _selected.add(name);
        _searchQuery = '';
        _searchController.clear();
      });
    }

    _createController.clear();
    _createFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

  List<Tag> get _filteredTags {
    if (_searchQuery.isEmpty) return _allTags;
    return _allTags.where((t) =>
      t.name.toLowerCase().contains(_searchQuery.toLowerCase()),
    ).toList();
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                ? Center(child: Text(
                    _searchQuery.isNotEmpty ? l10n.noTagsForQuery : l10n.noTags,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ))
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

