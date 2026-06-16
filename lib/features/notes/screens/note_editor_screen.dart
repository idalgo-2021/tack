import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/file_utils.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/constants/defaults.dart';
import '../../../data/models/note.dart';
import '../../../data/models/tag.dart';
import '../../../data/repositories/note_repository.dart';
import '../../../data/repositories/tag_repository.dart';
import '../providers/note_detail_provider.dart';
import '../providers/note_list_provider.dart';
import '../widgets/note_text_field.dart';
import '../widgets/tag_chips_field.dart';
import '../../media/widgets/audio_player_widget.dart';
import '../../media/widgets/image_grid_widget.dart';
import '../../media/providers/media_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../../tags/providers/tag_provider.dart';
import '../../tags/screens/tag_manager_screen.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final int? existingNoteId;

  const NoteEditorScreen({super.key, this.existingNoteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _textController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _focusNode = FocusNode();

  List<String> _tags = [];
  List<String> _imagePaths = [];
  List<String> _audioPaths = [];
  List<String> _filePaths = [];
  double? _latitude;
  double? _longitude;
  bool _isLoading = true;
  bool _hasChanges = false;
  Note? _existingNote;
  bool _geoRequested = false;
  bool _canPop = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _loadNote();
    if (widget.existingNoteId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    }
  }

  void _onTextChanged() {
    if (!_hasChanges && !_isLoading) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> _loadNote() async {
    if (widget.existingNoteId == null) {
      final autoGeo = ref.read(autoGeotagProvider);
      if (autoGeo && mounted) {
        _requestAutoLocation();
      }
      setState(() => _isLoading = false);
      return;
    }

    final note = await ref.read(noteDetailProvider(widget.existingNoteId!).future);
    if (note != null && mounted) {
      setState(() {
        _existingNote = note;
        _textController.text = note.text ?? '';
        _tags = List.from(note.tags);
        _imagePaths = List.from(note.imagePaths);
        _audioPaths = List.from(note.audioPaths);
        _filePaths = List.from(note.filePaths);
        _latitude = note.latitude;
        _longitude = note.longitude;
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  bool get _isEmptyNote =>
      _textController.text.trim().isEmpty &&
      _tags.isEmpty &&
      _imagePaths.isEmpty &&
      _audioPaths.isEmpty &&
      _filePaths.isEmpty;

  Future<void> _requestAutoLocation() async {
    if (_geoRequested) return;
    _geoRequested = true;
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      if (mounted) {
        setState(() {
          _latitude = pos.latitude;
          _longitude = pos.longitude;
        });
      }
    } catch (_) {}
  }

  Future<void> _pickImage(ImageSource source) async {
    final xFile = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: ref.read(compressImagesProvider) ? AppDefaults.imageQuality : null,
    );
    if (xFile == null) return;

    final savedPath = await FileUtils.copyToImages(xFile.path);
    setState(() {
      _imagePaths.add(savedPath);
      _hasChanges = true;
    });
  }

  Future<void> _recordAudio() async {
    final notifier = ref.read(mediaRecorderProvider.notifier);
    final isRecording = ref.read(mediaRecorderProvider);

    if (isRecording) {
      final path = await notifier.stopRecording();
      if (path != null && mounted) {
        setState(() {
          _audioPaths.add(path);
          _hasChanges = true;
        });
      }
    } else {
      await notifier.startRecording();
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles();
    if (result == null || result.files.isEmpty) return;

    for (final file in result.files) {
      final path = file.path;
      if (path == null) continue;
      final savedPath = await FileUtils.copyToFiles(path);
      _filePaths.add(savedPath);
    }
    setState(() {
      _hasChanges = true;
    });
  }

  Future<void> _requestLocation() async {
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
    }
  }

  Future<void> _clearLocation() async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteGeotag),
        content: Text(l10n.deleteGeotagConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      setState(() {
        _latitude = null;
        _longitude = null;
        _hasChanges = true;
      });
    }
  }

  Future<void> _save() async {
    final updateTs = ref.read(updateTimestampOnEditProvider);
    final createdAt = _existingNote != null && updateTs
        ? DateTime.now()
        : _existingNote?.createdAt ?? DateTime.now();

    final note = Note(
      id: _existingNote?.id,
      text: _textController.text.isEmpty ? null : _textController.text,
      tags: _tags,
      imagePaths: _imagePaths,
      audioPaths: _audioPaths,
      filePaths: _filePaths,
      createdAt: createdAt,
      latitude: _latitude,
      longitude: _longitude,
    );

    final repo = NoteRepository();
    if (note.id == null) {
      await repo.insert(note);
    } else {
      await repo.update(note);
    }
    ref.invalidate(noteListProvider);
    ref.invalidate(tagListProvider);
  }

  void _forcePop() {
    setState(() => _canPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showTagSelector() {
    final l10n = AppLocalizations.of(context);
    final allTagsAsync = ref.read(tagListProvider);
    final allTags = allTagsAsync.asData?.value ?? [];
    if (allTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noTagsCreated)),
      );
      return;
    }

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
        },
      ),
    );
  }

  void _showImageSourcePicker() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.makePhoto),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final autoSave = ref.watch(autoSaveProvider);
    final isRecording = ref.watch(mediaRecorderProvider);
    final showTs = ref.watch(showTimestampProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final hasLocation = _latitude != null && _longitude != null;

    TextStyle editorStyle() {
      final base = theme.textTheme.bodyLarge!;
      switch (fontSize) {
        case FontSize.small: return base.copyWith(fontSize: 14);
        case FontSize.medium: return base;
        case FontSize.large: return base.copyWith(fontSize: 20);
      }
    }

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_isEmptyNote && widget.existingNoteId == null) {
          final save = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.emptyNote),
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
          if (save == true) {
            await _save();
          }
          if (context.mounted) _forcePop();
          return;
        }
        if (autoSave) {
          await _save();
          if (context.mounted) _forcePop();
        } else if (_hasChanges) {
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
            if (context.mounted) _forcePop();
          } else {
            await _save();
            if (context.mounted) _forcePop();
          }
        } else {
          if (context.mounted) _forcePop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_existingNote != null ? l10n.editNote : l10n.newNote),
          actions: [
            if (!autoSave)
              TextButton(
                onPressed: () async {
                  await _save();
                  if (context.mounted) _forcePop();
                },
                child: Text(l10n.done),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showTs || hasLocation)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      if (showTs)
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 6),
                            Text(
                              DateFormatter.formatAbsoluteWithWeekday(_existingNote?.createdAt ?? DateTime.now()),
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
                ),
              NoteTextField(
                controller: _textController,
                focusNode: _focusNode,
                hintText: l10n.startWriting,
                textStyle: editorStyle(),
              ),
              const SizedBox(height: 24),
              Text(l10n.tags, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TagChipsField(
                tags: _tags,
                onChanged: (tags) {
                  setState(() {
                    _tags = tags;
                    _hasChanges = true;
                  });
                },
                onSearch: (query) async {
                  final repo = TagRepository();
                  return repo.searchNames(query);
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _showTagSelector,
                    icon: const Icon(Icons.label, size: 18),
                    label: Text(l10n.selectTag),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TagManagerScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings, size: 18),
                    label: Text(l10n.manage),
                  ),
                ],
              ),
              if (_imagePaths.isNotEmpty) ...[
                const SizedBox(height: 24),
                ImageGridWidget(
                  imagePaths: _imagePaths,
                  onDelete: (path) {
                    setState(() {
                      _imagePaths.remove(path);
                      _hasChanges = true;
                    });
                  },
                ),
              ],
              if (_audioPaths.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l10n.audio, style: theme.textTheme.titleSmall),
                ..._audioPaths.map((path) => AudioPlayerWidget(
                      audioPath: path,
                      onDelete: () {
                        setState(() {
                          _audioPaths.remove(path);
                          _hasChanges = true;
                        });
                      },
                    )),
              ],
              if (_filePaths.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l10n.files, style: theme.textTheme.titleSmall),
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
                          },
                        ),
                      ),
                    )),
              ],
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _showImageSourcePicker,
                    icon: const Icon(Icons.photo_camera),
                    label: Text(l10n.addPhoto),
                  ),
                  OutlinedButton.icon(
                    onPressed: _recordAudio,
                    icon: Icon(
                      isRecording ? Icons.stop : Icons.mic,
                      color: isRecording ? Colors.red : null,
                    ),
                    label: Text(isRecording ? l10n.stopLabel : l10n.recordAudio),
                  ),
                  OutlinedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: Text(l10n.addFile),
                  ),
                  OutlinedButton.icon(
                    onPressed: hasLocation ? _clearLocation : _requestLocation,
                    icon: Icon(
                      Icons.location_on,
                      color: hasLocation ? theme.colorScheme.primary : null,
                    ),
                    label: Text(hasLocation ? DateFormatter.formatDMS(_latitude!, _longitude!) : 'Geo'),
                  ),
                ],
              ),
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
  late Set<String> _selected;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.initialSelected);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Tag> get _filteredTags {
    if (_searchQuery.isEmpty) return widget.allTags;
    return widget.allTags.where((t) =>
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
