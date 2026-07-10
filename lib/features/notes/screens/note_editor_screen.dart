import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:geolocator/geolocator.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/date_formatter.dart';

import '../../../core/utils/file_utils.dart';
import '../../../data/models/note.dart';
import '../../media/widgets/audio_player_widget.dart';
import '../../media/widgets/file_thumbnail_grid.dart';
import '../../media/widgets/recording_banner.dart';

import '../../media/providers/media_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../widgets/note_editor_base.dart';
import '../widgets/note_action_buttons.dart';
import '../widgets/note_formatting_toolbar.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final Note? existingNote;

  const NoteEditorScreen({super.key, this.existingNote});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends NoteEditorState<NoteEditorScreen> {
  Note? get _existingNote => widget.existingNote;

  @override
  int? get noteIdForSave => _existingNote?.id ?? savedNoteId;

  @override
  DateTime get effectiveCreatedAt => _existingNote?.createdAt ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    final doc = Note.parseText(_existingNote?.text);
    initQuillController(doc ?? Document());
    imagePaths = List.from(_existingNote?.imagePaths ?? []);
    audioPaths = List.from(_existingNote?.audioPaths ?? []);
    filePaths = List.from(_existingNote?.filePaths ?? []);
    videoPaths = List.from(_existingNote?.videoPaths ?? []);
    tagNames = List.from(_existingNote?.tagNames ?? []);
    latitude = _existingNote?.latitude;
    longitude = _existingNote?.longitude;
    noteColor = _existingNote?.color;
    isPinned = _existingNote?.isPinned ?? false;
    updatedAt = _existingNote?.updatedAt ?? DateTime.now();

    if (_existingNote == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => focusNode.requestFocus());
      if (ref.read(autoGeotagProvider)) {
        _requestAutoLocation();
      }
    }
  }

  Future<void> _requestAutoLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      if (mounted) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
          hasChanges = true;
        });
        if (ref.read(autoSaveProvider)) scheduleAutoSave();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).locationPermissionDenied)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final autoSave = ref.watch(autoSaveProvider);
    final isRecording = ref.watch(mediaRecorderProvider);
    final showTs = ref.watch(showTimestampProvider);
    final mq = MediaQuery.of(context);
    final isTablet = mq.size.shortestSide >= 600;
    final leftPad = isTablet ? 64.0 : 0.0;

    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (!autoSave && hasChanges) {
          if (!isEmptyNote) {
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
        await saveNote();
        if (context.mounted) Navigator.pop(context);
      } else if (confirm == false) {
        await FileUtils.deleteFiles(newFilePaths.toList());
        newFilePaths.clear();
        if (context.mounted) Navigator.pop(context);
      }
    } else if (mounted) {
      setState(() => hasChanges = false);
    }
  } else if (autoSave && hasChanges) {
    await saveNote();
    if (context.mounted) Navigator.pop(context);
  }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_existingNote != null ? l10n.editNote : l10n.newNote),
          actions: [
            if (!autoSave)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilledButton(
                  onPressed: hasChanges ? () async {
                    await saveNote();
                    if (context.mounted) Navigator.pop(context);
                  } : null,
                  child: Text(l10n.save),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            if (isRecording) const RecordingBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16 + leftPad, 16, 16, 200),
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
                              DateFormatter.formatAbsoluteWithWeekday(updatedAt, Localizations.localeOf(context).languageCode),
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
                              DateFormatter.formatDMS(latitude!, longitude!),
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
                        ...tagNames.map((name) => Chip(
                          label: Text('#$name', style: const TextStyle(fontSize: 12)),
                          onDeleted: () {
                            setState(() {
                              tagNames.remove(name);
                              hasChanges = true;
                            });
                            if (autoSave) scheduleAutoSave();
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
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
                    const SizedBox(height: 16),
                    QuillEditor.basic(
                      controller: quillController,
                      focusNode: focusNode,
                      config: QuillEditorConfig(
                        placeholder: l10n.startWriting,
                        padding: EdgeInsets.zero,
                        scrollable: false,
                        expands: false,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                      if (cameraPaths.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(l10n.camera, style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        FileThumbnailGrid(
                          filePaths: cameraPaths,
                          showLabels: true,
                          previewPaths: allPreviewPaths,
                          onDelete: (path) {
                            setState(() {
                              imagePaths.remove(path);
                              videoPaths.remove(path);
                              hasChanges = true;
                              onFilePathsChanged();
                            });
                            handleFileRemoved(path);
                            if (autoSave) scheduleAutoSave();
                          },
                        ),
                      ],
                    if (audioPaths.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(l10n.audio, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      ...audioPaths.map((audioPath) => AudioPlayerWidget(
                        key: ValueKey(audioPath),
                        audioPath: audioPath,
                        onDelete: () {
                          setState(() {
                            audioPaths.remove(audioPath);
                            hasChanges = true;
                            onFilePathsChanged();
                          });
                          handleFileRemoved(audioPath);
                          if (autoSave) scheduleAutoSave();
                        },
                      ))

                    ],
                      if (allFilePaths.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(l10n.files, style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
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
                              onFilePathsChanged();
                            });
                            handleFileRemoved(path);
                            if (autoSave) scheduleAutoSave();
                          },
                        ),
                      ],
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showFormattingToolbar)
                  NoteFormattingToolbar(
                    controller: quillController,
                    onExit: toggleFormattingToolbar,
                  ),
                if (!showFormattingToolbar)
                  NoteActionButtons(
                    hasLocation: hasLocation,
                    onBeforeAttachment: confirmSaveForAttachment,
                    onImageAdded: (path) {
                      setState(() {
                        imagePaths.add(path);
                        newFilePaths.add(path);
                        hasChanges = true;
                        onFilePathsChanged();
                      });
                      if (autoSave) scheduleAutoSave();
                    },
                    onVideoAdded: (path) {
                      setState(() {
                        videoPaths.add(path);
                        newFilePaths.add(path);
                        hasChanges = true;
                        onFilePathsChanged();
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
                        onFilePathsChanged();
                      });
                      if (autoSave) scheduleAutoSave();
                    },
                    onLatitudeChanged: (lat) {
                      setState(() {
                        latitude = lat;
                        hasChanges = true;
                      });
                    },
                    onLongitudeChanged: (lon) {
                      setState(() {
                        longitude = lon;
                        hasChanges = true;
                      });
                    },
                    onLocationCleared: () {
                      setState(() {
                        latitude = null;
                        longitude = null;
                        hasChanges = true;
                      });
                    },
                    onFormatToggle: toggleFormattingToolbar,
                    showingFormattingToolbar: showFormattingToolbar,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
