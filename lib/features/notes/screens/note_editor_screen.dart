import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/file_utils.dart';
import '../../../data/models/note.dart';
import '../../../core/providers/repository_providers.dart';
import '../widgets/note_text_field.dart';
import '../../media/widgets/audio_player_widget.dart';
import '../../media/widgets/file_thumbnail_grid.dart';
import '../../media/widgets/image_grid_widget.dart';
import '../../media/widgets/recording_banner.dart';
import '../../media/providers/media_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../../tags/providers/tag_provider.dart';
import '../../tags/widgets/tag_selector_dialog.dart';
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

  final Set<String> _newFilePaths = {};
  final Set<String> _deletedFilePaths = {};

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
          _latitude = position.latitude;
          _longitude = position.longitude;
          _hasChanges = true;
        });
        if (ref.read(autoSaveProvider)) _scheduleAutoSave();
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

  void _handleFileRemoved(String path) {
    if (_newFilePaths.contains(path)) {
      _newFilePaths.remove(path);
      FileUtils.deleteFile(path);
    } else {
      _deletedFilePaths.add(path);
    }
  }

  Future<void> _saveNote() async {
    final now = DateTime.now();

    if (_isEmptyNote) {
      if (mounted) setState(() => _hasChanges = false);
      return;
    }

    final noteId = _existingNote?.id ?? _savedNoteId;
    final note = Note(
      id: noteId,
      text: _textController.text.trim().isEmpty ? null : _textController.text.trim(),
      tags: _tagNames,
      imagePaths: _imagePaths,
      audioPaths: _audioPaths,
      filePaths: _filePaths,
      createdAt: _existingNote?.createdAt ?? now,
      latitude: _latitude,
      longitude: _longitude,
    );

    final repo = ref.read(noteRepositoryProvider);
    if (noteId != null) {
      await repo.update(note);
    } else {
      final id = await repo.insert(note);
      _savedNoteId = id;
    }

    ref.invalidate(noteListProvider);
    ref.invalidate(tagListProvider);

    await FileUtils.deleteFiles(_deletedFilePaths.toList());
    _newFilePaths.clear();
    _deletedFilePaths.clear();

    if (mounted) {
      setState(() => _hasChanges = false);
    }
  }

  Future<void> _showTagSelector() async {
    ref.invalidate(tagListProvider);
    final repo = ref.read(tagRepositoryProvider);
    final allTags = await repo.getAll();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => TagSelectorDialog(
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
    final showThumbnails = ref.watch(showFileThumbnailsProvider);

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
            } else {
              await FileUtils.deleteFiles(_newFilePaths.toList());
              _newFilePaths.clear();
            }
          } else if (mounted) {
            setState(() => _hasChanges = false);
          }
        } else if (autoSave && _hasChanges) {
          await _saveNote();
        }
        if (context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_existingNote != null ? l10n.editNote : l10n.newNote),
          actions: [
            if (!autoSave)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilledButton(
                  onPressed: _hasChanges ? () async {
                    await _saveNote();
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
                          _handleFileRemoved(path);
                          if (autoSave) _scheduleAutoSave();
                        },
                      ),
                    ],
                    if (_audioPaths.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(l10n.audio, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      ..._audioPaths.map((audioPath) => AudioPlayerWidget(
                        key: ValueKey(audioPath),
                        audioPath: audioPath,
                        onDelete: () {
                          setState(() {
                            _audioPaths.remove(audioPath);
                            _hasChanges = true;
                          });
                          _handleFileRemoved(audioPath);
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
                                _handleFileRemoved(path);
                                if (autoSave) _scheduleAutoSave();
                              },
                            ),
                          ),
                        )),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: NoteActionButtons(
          hasLocation: hasLocation,
          onImageAdded: (path) {
            setState(() {
              _imagePaths.add(path);
              _newFilePaths.add(path);
              _hasChanges = true;
            });
          },
          onAudioAdded: (path) {
            setState(() {
              _audioPaths.insert(0, path);
              _newFilePaths.add(path);
              _hasChanges = true;
            });
          },
          onFileAdded: (path) {
            setState(() {
              _filePaths.add(path);
              _newFilePaths.add(path);
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


