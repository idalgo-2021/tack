import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../core/constants/app_constants.dart';

class FileUtils {
  static Future<String> get _appDir async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<String> _appDirCanonical() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.resolveSymbolicLinksSync();
  }

  static Future<String> _dir(String subPath) async {
    final base = await _appDir;
    final path = p.join(base, subPath);
    await Directory(path).create(recursive: true);
    return path;
  }

  static Future<bool> isWithinAppDir(String path) async {
    if (path.isEmpty) return false;
    final appDir = await _appDirCanonical();
    final normalized = p.normalize(path);
    final root = p.join(appDir, p.separator);
    return normalized == appDir || normalized.startsWith(root);
  }

  static Future<String> _ensureWithinAppDir(String path) async {
    if (!await isWithinAppDir(path)) {
      throw FileSystemException('Path outside app directory', path);
    }
    return path;
  }

  static Future<String> get imagesDir async => _dir(AppConstants.imagesDir);
  static Future<String> get audioDir async => _dir(AppConstants.audioDir);
  static Future<String> get filesDir async => _dir(AppConstants.filesDir);
  static Future<String> get videosDir async => _dir(AppConstants.videosDir);
  static Future<String> get cameraImagesDir async => _dir(AppConstants.cameraImagesDir);
  static Future<String> get cameraVideosDir async => _dir(AppConstants.cameraVideosDir);

  static Future<String> copyToImages(String sourcePath) async {
    final dir = await imagesDir;
    final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourcePath)}';
    final dest = p.join(dir, name);
    await _ensureWithinAppDir(dest);
    await File(sourcePath).copy(dest);
    return dest;
  }

  static Future<String> copyToAudio(String sourcePath) async {
    final dir = await audioDir;
    final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourcePath)}';
    final dest = p.join(dir, name);
    await _ensureWithinAppDir(dest);
    await File(sourcePath).copy(dest);
    return dest;
  }

  static Future<String> copyToFiles(String sourcePath) async {
    final dir = await filesDir;
    final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourcePath)}';
    final dest = p.join(dir, name);
    await _ensureWithinAppDir(dest);
    await File(sourcePath).copy(dest);
    return dest;
  }

  static Future<String> copyToVideos(String sourcePath) async {
    final dir = await videosDir;
    final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourcePath)}';
    final dest = p.join(dir, name);
    await _ensureWithinAppDir(dest);
    return dest;
  }

  static Future<String> copyToCameraImages(String sourcePath) async {
    final dir = await cameraImagesDir;
    final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourcePath)}';
    final dest = p.join(dir, name);
    await _ensureWithinAppDir(dest);
    await File(sourcePath).copy(dest);
    return dest;
  }

  static Future<String> copyToCameraVideos(String sourcePath) async {
    final dir = await cameraVideosDir;
    final name = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourcePath)}';
    final dest = p.join(dir, name);
    await _ensureWithinAppDir(dest);
    await File(sourcePath).copy(dest);
    return dest;
  }

  static bool isCameraFile(String path) => path.contains('/camera/');

  static Future<void> deleteFile(String path) async {
    await _ensureWithinAppDir(path);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
    final thumb = File('${path}_thumb.jpg');
    if (await thumb.exists()) {
      await thumb.delete();
    }
  }

  static Future<void> deleteFiles(List<String> paths) async {
    final errors = <Object>[];
    for (final path in paths) {
      try {
        await deleteFile(path);
      } catch (e) {
        errors.add(e);
      }
    }
    if (errors.isNotEmpty) {
      throw AggregateException(errors);
    }
  }
}

class AggregateException implements Exception {
  final List<Object> errors;
  AggregateException(this.errors);

  @override
  String toString() => errors.join('; ');
}
