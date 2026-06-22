import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/export_helper.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/file_type_icons.dart';

import '../../../core/utils/file_utils.dart';
import '../../../data/models/note.dart';
import '../../../core/providers/repository_providers.dart';
import '../providers/note_detail_provider.dart';
import '../providers/note_list_provider.dart';
import '../../media/widgets/audio_player_widget.dart';
import '../../media/widgets/file_thumbnail_grid.dart';
import '../../media/widgets/recording_banner.dart';
import '../../media/widgets/thumbnail_preview.dart';

import '../../media/providers/media_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../widgets/note_editor_base.dart';
import '../widgets/note_action_buttons.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  final int noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends NoteEditorState<NoteDetailScreen> {
  bool _initialized = false;

  @override
  int? get noteIdForSave => widget.noteId;

  @override
  DateTime get effectiveCreatedAt => _loadedCreatedAt ?? DateTime.now();

  DateTime? _loadedCreatedAt;

  @override
  void onNoteSaved(int? noteId) {
    ref.invalidate(noteDetailProvider(widget.noteId));
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (!_initialized) return;
    handleFieldChanged();
  }

  void _initFromNote(Note note) {
    textController.text = note.text ?? '';
    tagNames = List.from(note.tags);
    imagePaths = List.from(note.imagePaths);
    audioPaths = List.from(note.audioPaths);
    filePaths = List.from(note.filePaths);
    videoPaths = List.from(note.videoPaths);
    latitude = note.latitude;
    longitude = note.longitude;
    _loadedCreatedAt = note.createdAt;
    hasChanges = false;
    _initialized = true;
  }

  Future<void> _confirmDelete() async {
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
    final allPaths = [...imagePaths, ...audioPaths, ...filePaths, ...videoPaths];
    await FileUtils.deleteFiles(allPaths);
    final repo = ref.read(noteRepositoryProvider);
    await repo.delete(widget.noteId);
    if (mounted) {
      ref.invalidate(noteListProvider);
      Navigator.pop(context);
    }
  }

  Future<void> _shareNote(Note note) async {
    final l10n = AppLocalizations.of(context);
    final format = ref.read(exportFormatProvider);
    final zip = ref.read(zipExportProvider);
    final timestamp = DateFormatter.formatFileDate(note.createdAt);
    final allFiles = <XFile>[];

    if (format == ExportFormat.markdown) {
      final content = ExportHelper.notesToMarkdown([note], l10n);
      final file = File('${Directory.systemTemp.path}/tack_$timestamp.md');
      await file.writeAsString(content);
      allFiles.add(XFile(file.path));
    } else {
      final content = ExportHelper.notesToJson([note]);
      final file = File('${Directory.systemTemp.path}/tack_$timestamp.json');
      await file.writeAsString(content);
      allFiles.add(XFile(file.path));
    }

    if (zip) {
      final attachPaths = <String>[allFiles.first.path];
      for (final p in note.imagePaths) { attachPaths.add(p); }
      for (final p in note.audioPaths) { attachPaths.add(p); }
      for (final p in note.videoPaths) { attachPaths.add(p); }
      for (final p in note.filePaths) { attachPaths.add(p); }
      final zipPath = '${Directory.systemTemp.path}/tack_$timestamp.zip';
      await ExportHelper.createZip(zipPath, attachPaths);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(zipPath)]),
      );
    } else {
      for (final p in note.imagePaths) { allFiles.add(XFile(p)); }
      for (final p in note.audioPaths) { allFiles.add(XFile(p)); }
      for (final p in note.videoPaths) { allFiles.add(XFile(p)); }
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
    final showThumbnails = ref.watch(showFileThumbnailsProvider);
    final autoSave = ref.watch(autoSaveProvider);
    final theme = Theme.of(context);
    final isRecording = ref.watch(mediaRecorderProvider);
    

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

        return PopScope(
          canPop: !hasChanges,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            if (autoSave) {
              await saveNote();
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
                await FileUtils.deleteFiles(newFilePaths.toList());
                newFilePaths.clear();
                if (context.mounted) Navigator.of(context).pop();
              } else {
                await saveNote();
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
                      Clipboard.setData(ClipboardData(text: textController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.textCopied)),
                      );
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _shareNote(note),
                ),
                if (!autoSave && hasChanges)
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: saveNote,
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _confirmDelete,
                ),
              ],
            ),
            body: GestureDetector(
              onTap: () => focusNode.requestFocus(),
              behavior: HitTestBehavior.translucent,
              child: Column(
              children: [
                if (hasChanges)
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
                                    DateFormatter.formatAbsoluteWithWeekday(effectiveCreatedAt),
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
                                    DateFormatter.formatDMS(latitude!, longitude!),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        if (tagNames.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              ...tagNames.map((tag) => Chip(
                                label: Text('#$tag', style: const TextStyle(fontSize: 12)),
                                onDeleted: () {
                                  setState(() {
                                    tagNames.remove(tag);
                                    hasChanges = true;
                                  });
                                  if (autoSave) scheduleAutoSave();
                                },
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                deleteIcon: const Icon(Icons.close, size: 16),
                                deleteIconColor: theme.colorScheme.onSurfaceVariant,
                              )),
                              ActionChip(
                                label: Text(l10n.selectTags, style: const TextStyle(fontSize: 12)),
                                avatar: const Icon(Icons.add, size: 16),
                                onPressed: showTagSelector,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: showTagSelector,
                            icon: const Icon(Icons.label, size: 16),
                            label: Text(l10n.selectTag, style: const TextStyle(fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextField(
                          controller: textController,
                          focusNode: focusNode,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isCollapsed: true,
                            hintText: textController.text.isEmpty ? l10n.startWriting : null,
                            hintStyle: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                        if (cameraPaths.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(l10n.camera, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 8),
                          if (showThumbnails)
                            FileThumbnailGrid(
                              filePaths: cameraPaths,
                              showLabels: true,
                              previewPaths: allPreviewPaths,
                              onDelete: (path) {
                                setState(() {
                                  imagePaths.remove(path);
                                  videoPaths.remove(path);
                                  hasChanges = true;
                                });
                                handleFileRemoved(path);
                                if (autoSave) scheduleAutoSave();
                              },
                            )
                          else
                            ...cameraPaths.map((p) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              child: ListTile(
                                dense: true,
                                leading: Icon(isImageFile(p) ? Icons.image : Icons.videocam),
                                title: Text(p.split('/').last, style: const TextStyle(fontSize: 13)),
                                onTap: () => ThumbnailPreview.show(context, allPreviewPaths, initialIndex: allPreviewPaths.indexOf(p)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      imagePaths.remove(p);
                                      videoPaths.remove(p);
                                      hasChanges = true;
                                    });
                                    handleFileRemoved(p);
                                    if (autoSave) scheduleAutoSave();
                                  },
                                ),
                              ),
                            )),
                        ],
                        if (audioPaths.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(l10n.audio, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 8),
                          ...audioPaths.map((path) => AudioPlayerWidget(
                            key: ValueKey(path),
                            audioPath: path,
                            onDelete: () {
                              setState(() {
                                audioPaths.remove(path);
                                hasChanges = true;
                              });
                              handleFileRemoved(path);
                              if (autoSave) scheduleAutoSave();
                            },
                          )),
                        ],
                        if (allFilePaths.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(l10n.files, style: theme.textTheme.titleSmall),
                          const SizedBox(height: 8),
                          if (showThumbnails)
                            FileThumbnailGrid(
                              filePaths: allFilePaths,
                              showLabels: true,
                              previewPaths: allPreviewPaths,
                              onDelete: (path) {
                                setState(() {
                                  imagePaths.remove(path);
                                  videoPaths.remove(path);
                                  filePaths.remove(path);
                                  hasChanges = true;
                                });
                                handleFileRemoved(path);
                                if (autoSave) scheduleAutoSave();
                              },
                            )
                          else
                            ...allFilePaths.map((p) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              child: ListTile(
                                dense: true,
                                leading: Icon(isImageFile(p)
                                    ? Icons.image
                                    : isVideoFile(p)
                                        ? Icons.videocam
                                        : fileIcon(p)),
                                title: Text(p.split('/').last, style: const TextStyle(fontSize: 13)),
                                onTap: () => ThumbnailPreview.show(context, allPreviewPaths, initialIndex: allPreviewPaths.indexOf(p)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      imagePaths.remove(p);
                                      videoPaths.remove(p);
                                      filePaths.remove(p);
                                      hasChanges = true;
                                    });
                                    handleFileRemoved(p);
                                    if (autoSave) scheduleAutoSave();
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
                  imagePaths.add(path);
                  newFilePaths.add(path);
                  hasChanges = true;
                });
                if (autoSave) scheduleAutoSave();
              },
              onVideoAdded: (path) {
                setState(() {
                  videoPaths.add(path);
                  newFilePaths.add(path);
                  hasChanges = true;
                });
                if (autoSave) scheduleAutoSave();
              },
              onAudioAdded: (path) {
                setState(() {
                  audioPaths.insert(0, path);
                  newFilePaths.add(path);
                  hasChanges = true;
                });
                if (autoSave) scheduleAutoSave();
              },
              onFileAdded: (path) {
                setState(() {
                  filePaths.add(path);
                  newFilePaths.add(path);
                  hasChanges = true;
                });
                if (autoSave) scheduleAutoSave();
              },
              onLatitudeChanged: (lat) {
                setState(() {
                  latitude = lat;
                  hasChanges = true;
                });
                if (autoSave) scheduleAutoSave();
              },
              onLongitudeChanged: (lon) {
                setState(() {
                  longitude = lon;
                  hasChanges = true;
                });
                if (autoSave) scheduleAutoSave();
              },
              onLocationCleared: () {
                setState(() {
                  latitude = null;
                  longitude = null;
                  hasChanges = true;
                });
                if (autoSave) scheduleAutoSave();
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
