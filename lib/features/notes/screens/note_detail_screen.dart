import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/export_helper.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/file_utils.dart';
import '../../../data/models/note.dart';
import '../../../core/providers/repository_providers.dart';
import '../providers/note_detail_provider.dart';
import '../providers/note_list_provider.dart';
import '../../media/widgets/audio_player_widget.dart';
import '../../media/widgets/file_thumbnail_grid.dart';
import '../../media/widgets/image_grid_widget.dart';
import '../../media/widgets/recording_banner.dart';
import '../../media/providers/media_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../../tags/providers/tag_provider.dart';
import '../../tags/widgets/tag_selector_dialog.dart';
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

  final Set<String> _newFilePaths = {};
  final Set<String> _deletedFilePaths = {};

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

  void _handleFileRemoved(String path) {
    if (_newFilePaths.contains(path)) {
      _newFilePaths.remove(path);
      FileUtils.deleteFile(path);
    } else {
      _deletedFilePaths.add(path);
    }
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
    final note = Note(
      id: widget.noteId,
      text: _textController.text.isEmpty ? null : _textController.text,
      tags: _tags,
      imagePaths: _imagePaths,
      audioPaths: _audioPaths,
      filePaths: _filePaths,
      createdAt: _createdAt ?? DateTime.now(),
      latitude: _latitude,
      longitude: _longitude,
    );
    final repo = ref.read(noteRepositoryProvider);
    await repo.update(note);
    ref.invalidate(noteListProvider);
    ref.invalidate(tagListProvider);
    ref.invalidate(noteDetailProvider(widget.noteId));

    await FileUtils.deleteFiles(_deletedFilePaths.toList());
    _newFilePaths.clear();
    _deletedFilePaths.clear();

    _hasChanges = false;
  }

  Future<void> _showTagSelector() async {
    final l10n = AppLocalizations.of(context);
    ref.invalidate(tagListProvider);
    final repo = ref.read(tagRepositoryProvider);
    final allTags = await repo.getAll();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => TagSelectorDialog(
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
    final allPaths = [..._imagePaths, ..._audioPaths, ..._filePaths];
    await FileUtils.deleteFiles(allPaths);
    final repo = ref.read(noteRepositoryProvider);
    await repo.delete(widget.noteId);
    if (context.mounted) {
      ref.invalidate(noteListProvider);
      Navigator.pop(context);
    }
  }

  Future<void> _shareNote(dynamic note) async {
    final l10n = AppLocalizations.of(context);
    final format = ref.read(exportFormatProvider);
    final zip = ref.read(zipExportProvider);
    final timestamp = DateFormatter.formatFileDate(note.createdAt);
    final allFiles = <XFile>[];

    if (format == ExportFormat.markdown) {
      final content = ExportHelper.notesToMarkdown([note], l10n);
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
    final isRecording = ref.watch(mediaRecorderProvider);
    final showThumbnails = ref.watch(showFileThumbnailsProvider);

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
                await FileUtils.deleteFiles(_newFilePaths.toList());
                _newFilePaths.clear();
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
                if (isRecording) const RecordingBanner(),
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
                              _handleFileRemoved(path);
                              if (autoSave) _scheduleAutoSave();
                            },
                          ),
                        ],
                        if (_audioPaths.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(l10n.audio, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 8),
                          ..._audioPaths.map((path) => AudioPlayerWidget(
                            key: ValueKey(path),
                            audioPath: path,
                            onDelete: () {
                              setState(() {
                                _audioPaths.remove(path);
                                _hasChanges = true;
                              });
                              _handleFileRemoved(path);
                              if (autoSave) _scheduleAutoSave();
                            },
                          )),
                        ],
                        if (_filePaths.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(l10n.files, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 8),
                          if (showThumbnails)
                            FileThumbnailGrid(
                              filePaths: _filePaths,
                              onDelete: (path) {
                                setState(() {
                                  _filePaths.remove(path);
                                  _hasChanges = true;
                                });
                                _handleFileRemoved(path);
                                if (autoSave) _scheduleAutoSave();
                              },
                            )
                          else
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
                                    _handleFileRemoved(path);
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
                  _newFilePaths.add(path);
                  _hasChanges = true;
                });
                if (autoSave) _scheduleAutoSave();
              },
              onAudioAdded: (path) {
                setState(() {
                  _audioPaths.insert(0, path);
                  _newFilePaths.add(path);
                  _hasChanges = true;
                });
                if (autoSave) _scheduleAutoSave();
              },
              onFileAdded: (path) {
                setState(() {
                  _filePaths.add(path);
                  _newFilePaths.add(path);
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



