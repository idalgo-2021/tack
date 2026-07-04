import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/file_utils.dart';
import '../../media/providers/media_provider.dart';

class NoteActionButtons extends ConsumerStatefulWidget {
  final bool hasLocation;
  final ValueChanged<String> onImageAdded;
  final ValueChanged<String> onVideoAdded;
  final ValueChanged<String> onAudioAdded;
  final ValueChanged<String> onFileAdded;
  final ValueChanged<double> onLatitudeChanged;
  final ValueChanged<double> onLongitudeChanged;
  final VoidCallback onLocationCleared;
  final VoidCallback? onFormatToggle;
  final bool showingFormattingToolbar;
  final Future<bool> Function()? onBeforeAttachment;

  const NoteActionButtons({
    super.key,
    required this.hasLocation,
    required this.onImageAdded,
    required this.onVideoAdded,
    required this.onAudioAdded,
    required this.onFileAdded,
    required this.onLatitudeChanged,
    required this.onLongitudeChanged,
    required this.onLocationCleared,
    this.onFormatToggle,
    this.showingFormattingToolbar = false,
    this.onBeforeAttachment,
  });

  @override
  ConsumerState<NoteActionButtons> createState() => _NoteActionButtonsState();
}

class _NoteActionButtonsState extends ConsumerState<NoteActionButtons> {
  Future<void> _pickMedia() async {
    if (widget.onBeforeAttachment != null && !await widget.onBeforeAttachment!()) return;
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.makePhoto),
              onTap: () => Navigator.pop(ctx, 'photo'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(l10n.recordVideo),
              onTap: () => Navigator.pop(ctx, 'video'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.chooseFromGallery),
              onTap: () => Navigator.pop(ctx, 'gallery'),
            ),
          ],
        ),
      ),
    );
    if (action == null) return;

    final notifier = ref.read(imagePickingProvider.notifier);
    switch (action) {
      case 'photo':
        final path = await notifier.takePhoto();
        if (path != null) widget.onImageAdded(path);
      case 'video':
        final path = await notifier.recordVideo();
        if (path != null) widget.onVideoAdded(path);
      case 'gallery':
        final path = await notifier.pickMedia();
        if (path != null) {
          final ext = path.split('.').last.toLowerCase();
          const videoExts = {'mp4', 'avi', 'mkv', 'mov', 'webm', '3gp', 'm4v'};
          if (videoExts.contains(ext)) {
            widget.onVideoAdded(path);
          } else {
            widget.onImageAdded(path);
          }
        }
    }
  }

  Future<void> _recordAudio() async {
    final notifier = ref.read(mediaRecorderProvider.notifier);
    final isRecording = ref.read(mediaRecorderProvider);

    if (isRecording) {
      if (widget.onBeforeAttachment != null && !await widget.onBeforeAttachment!()) return;
      if (!mounted) return;
      final path = await notifier.stopRecording();
      if (path != null) {
        widget.onAudioAdded(path);
      }
    } else {
      final l10n = AppLocalizations.of(context);
      final result = await notifier.startRecording();
      if (result == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.recordingError)),
        );
      }
    }
  }

  Future<void> _pickFile() async {
    if (widget.onBeforeAttachment != null && !await widget.onBeforeAttachment!()) return;
    if (!mounted) return;
    final result = await FilePicker.pickFiles();
    if (result == null || result.files.isEmpty) return;

    for (final file in result.files) {
      final path = file.path;
      if (path == null) continue;
      final saved = await FileUtils.copyToFiles(path);
      widget.onFileAdded(saved);
    }
  }

  Future<void> _requestLocation() async {
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
      widget.onLatitudeChanged(position.latitude);
      widget.onLongitudeChanged(position.longitude);
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
    final isRecording = ref.watch(mediaRecorderProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _pickMedia,
              icon: const Icon(Icons.photo_camera),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: isRecording ? Colors.red : theme.colorScheme.onSecondaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _recordAudio,
              icon: Icon(isRecording ? Icons.stop : Icons.mic),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: widget.hasLocation
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSecondaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: widget.hasLocation ? widget.onLocationCleared : _requestLocation,
              icon: Icon(widget.hasLocation ? Icons.my_location : Icons.location_off),
            ),
            if (widget.onFormatToggle != null)
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: widget.showingFormattingToolbar
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSecondaryContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: widget.onFormatToggle,
                icon: const Icon(Icons.text_fields),
              ),
          ],
        ),
      ),
    );
  }
}
