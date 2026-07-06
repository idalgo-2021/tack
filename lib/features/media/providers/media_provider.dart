import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/utils/file_utils.dart';

part 'media_provider.g.dart';

@Riverpod(keepAlive: false)
class MediaRecorder extends _$MediaRecorder {
  final _recorder = AudioRecorder();
  String? _currentPath;

  @override
  bool build() {
    ref.onDispose(() async {
      if (state) {
        try {
          await _recorder.stop();
        } catch (_) {}
        if (_currentPath != null) {
          await FileUtils.deleteFile(_currentPath!);
        }
      }
      _recorder.dispose();
    });
    return false;
  }

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

@Riverpod(keepAlive: false)
class ImagePicking extends _$ImagePicking {
  final _picker = ImagePicker();

  @override
  List<String> build() => [];

  Future<String?> pickFromGallery() async {
    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,

    );
    if (xFile == null) return null;
    return FileUtils.copyToImages(xFile.path);
  }

  Future<String?> takePhoto() async {
    final xFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,

    );
    if (xFile == null) return null;
    return FileUtils.copyToCameraImages(xFile.path);
  }

  Future<String?> recordVideo() async {
    final xFile = await _picker.pickVideo(source: ImageSource.camera);
    if (xFile == null) return null;
    return FileUtils.copyToCameraVideos(xFile.path);
  }

  Future<String?> pickVideoFromGallery() async {
    final xFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (xFile == null) return null;
    return FileUtils.copyToVideos(xFile.path);
  }

  Future<String?> pickMedia() async {
    final xFile = await _picker.pickMedia();
    if (xFile == null) return null;
    final ext = xFile.path.split('.').last.toLowerCase();
    const videoExts = {'mp4', 'avi', 'mkv', 'mov', 'webm', '3gp', 'm4v'};
    if (videoExts.contains(ext)) {
      return FileUtils.copyToVideos(xFile.path);
    }
    return FileUtils.copyToImages(xFile.path);
  }
}

