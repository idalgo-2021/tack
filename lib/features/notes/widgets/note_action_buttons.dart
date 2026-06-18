import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/file_utils.dart';
import '../../media/providers/media_provider.dart';

class NoteActionButtons extends ConsumerStatefulWidget {
  final bool hasLocation;
  final ValueChanged<String> onImageAdded;
  final ValueChanged<String> onAudioAdded;
  final ValueChanged<String> onFileAdded;
  final ValueChanged<double> onLatitudeChanged;
  final ValueChanged<double> onLongitudeChanged;
  final VoidCallback onLocationCleared;

  const NoteActionButtons({
    super.key,
    required this.hasLocation,
    required this.onImageAdded,
    required this.onAudioAdded,
    required this.onFileAdded,
    required this.onLatitudeChanged,
    required this.onLongitudeChanged,
    required this.onLocationCleared,
  });

  @override
  ConsumerState<NoteActionButtons> createState() => _NoteActionButtonsState();
}

class _NoteActionButtonsState extends ConsumerState<NoteActionButtons> {
  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.makePhoto),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.chooseFromGallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final notifier = ref.read(imagePickingProvider.notifier);
    final path = source == ImageSource.camera
        ? await notifier.takePhoto()
        : await notifier.pickFromGallery();
    if (path != null) {
      widget.onImageAdded(path);
    }
  }

  Future<void> _recordAudio() async {
    final notifier = ref.read(mediaRecorderProvider.notifier);
    final isRecording = ref.read(mediaRecorderProvider);

    if (isRecording) {
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
    } catch (_) {}
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
              onPressed: _pickImage,
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
          ],
        ),
      ),
    );
  }
}
