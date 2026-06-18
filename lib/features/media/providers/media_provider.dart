import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/utils/file_utils.dart';

part 'media_provider.g.dart';

@Riverpod(keepAlive: true)
class MediaRecorder extends _$MediaRecorder {
  final _recorder = AudioRecorder();
  String? _currentPath;

  @override
  bool build() => false;

  Future<String?> startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return null;

    final dir = await FileUtils.audioDir;
    final path = '$dir/${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        numChannels: 1,
      ),
      path: path,
    );

    _currentPath = path;
    state = true;
    return path;
  }

  Future<String?> stopRecording() async {
    if (!state) return null;
    final path = await _recorder.stop();
    state = false;
    _currentPath = null;
    return path;
  }

  Future<void> cancelRecording() async {
    if (!state) return;
    await _recorder.stop();
    if (_currentPath != null) {
      await FileUtils.deleteFile(_currentPath!);
    }
    state = false;
    _currentPath = null;
  }


}

@riverpod
class ImagePicking extends _$ImagePicking {
  final _picker = ImagePicker();

  @override
  List<String> build() => [];

  Future<String?> pickFromGallery() async {
    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (xFile == null) return null;
    return FileUtils.copyToImages(xFile.path);
  }

  Future<String?> takePhoto() async {
    final xFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (xFile == null) return null;
    return FileUtils.copyToImages(xFile.path);
  }
}

