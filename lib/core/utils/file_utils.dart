import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FileUtils {
  static const _imagesDir = 'tack/images';
  static const _audioDir = 'tack/audio';
  static const _filesDir = 'tack/files';
  static const _videosDir = 'tack/videos';

  static Future<String> get _appDir async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<String> get imagesDir async {
    final base = await _appDir;
    final path = p.join(base, _imagesDir);
    await Directory(path).create(recursive: true);
    return path;
  }

  static Future<String> get audioDir async {
    final base = await _appDir;
    final path = p.join(base, _audioDir);
    await Directory(path).create(recursive: true);
    return path;
  }

  static Future<String> get filesDir async {
    final base = await _appDir;
    final path = p.join(base, _filesDir);
    await Directory(path).create(recursive: true);
    return path;
  }

  static Future<String> copyToImages(String sourcePath) async {
    final dir = await imagesDir;
    final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourcePath)}';
    final dest = p.join(dir, name);
    await File(sourcePath).copy(dest);
    return dest;
  }

  static Future<String> copyToAudio(String sourcePath) async {
    final dir = await audioDir;
    final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourcePath)}';
    final dest = p.join(dir, name);
    await File(sourcePath).copy(dest);
    return dest;
  }

  static Future<String> copyToFiles(String sourcePath) async {
    final dir = await filesDir;
    final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourcePath)}';
    final dest = p.join(dir, name);
    await File(sourcePath).copy(dest);
    return dest;
  }

  static Future<String> get videosDir async {
    final base = await _appDir;
    final path = p.join(base, _videosDir);
    await Directory(path).create(recursive: true);
    return path;
  }

  static Future<String> copyToVideos(String sourcePath) async {
    final dir = await videosDir;
    final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourcePath)}';
    final dest = p.join(dir, name);
    await File(sourcePath).copy(dest);
    return dest;
  }

  static Future<String> saveAudioFile(String destName, List<int> bytes) async {
    final dir = await audioDir;
    final dest = p.join(dir, destName);
    await File(dest).writeAsBytes(bytes);
    return dest;
  }

  static Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> deleteFiles(List<String> paths) async {
    for (final path in paths) {
      await deleteFile(path);
    }
  }
}
