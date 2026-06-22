import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_thumbnail_gen/video_thumbnail_gen.dart';
import '../../../core/utils/file_type_icons.dart';
import 'thumbnail_preview.dart';

String _truncateFileName(String name, int maxBaseLength) {
  final lastDot = name.lastIndexOf('.');
  if (lastDot <= 0) return name;
  final base = name.substring(0, lastDot);
  final ext = name.substring(lastDot);
  if (base.length <= maxBaseLength) return name;
  return '${base.substring(0, maxBaseLength)}...$ext';
}

String _ext(String path) {
  final i = path.lastIndexOf('.');
  return i == -1 ? '' : path.substring(i + 1).toLowerCase();
}

class FileThumbnailGrid extends StatelessWidget {
  final List<String> filePaths;
  final ValueChanged<String>? onDelete;
  final bool showLabels;
  final List<String>? previewPaths;

  const FileThumbnailGrid({
    super.key,
    required this.filePaths,
    this.onDelete,
    this.showLabels = true,
    this.previewPaths,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filePaths.map((path) => _buildTile(context, theme, path)).toList(),
    );
  }

  Widget _buildTile(BuildContext context, ThemeData theme, String path) {
    final name = path.split('/').last;
    const size = 100.0;
    final navPaths = previewPaths ?? filePaths;

    return GestureDetector(
      onTap: () => ThumbnailPreview.show(context, navPaths, initialIndex: navPaths.indexOf(path)),
      child: SizedBox(
        width: size,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isImageFile(path)
                  ? _imageThumbnail(path, size, theme)
                  : isVideoFile(path)
                      ? _VideoThumbnailTile(path: path, size: size, theme: theme, onDelete: onDelete)
                      : _iconTile(path, size, theme),
            ),
            if (showLabels) ...[
              const SizedBox(height: 4),
              Text(
                _truncateFileName(name, 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _imageThumbnail(String path, double size, ThemeData theme) {
    return Stack(
      children: [
        Image.file(
          File(path),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            width: size,
            height: size,
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(Icons.broken_image, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        if (onDelete != null)
          Positioned(
            top: 3,
            right: 3,
            child: GestureDetector(
              onTap: () => onDelete!(path),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _iconTile(String path, double size, ThemeData theme) {
    final ext = _ext(path).toUpperCase();
    final color = fileColor(path);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(fileIcon(path), size: 40, color: color),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                ext,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (onDelete != null)
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: () => onDelete!(path),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VideoThumbnailTile extends StatefulWidget {
  final String path;
  final double size;
  final ThemeData theme;
  final ValueChanged<String>? onDelete;

  const _VideoThumbnailTile({
    required this.path,
    required this.size,
    required this.theme,
    this.onDelete,
  });

  @override
  State<_VideoThumbnailTile> createState() => _VideoThumbnailTileState();
}

class _VideoThumbnailTileState extends State<_VideoThumbnailTile> {
  String? _thumbPath;
  int? _durationMs;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    final cachePath = '${widget.path}_thumb.jpg';
    final cacheFile = File(cachePath);

    _loadDuration();

    if (await cacheFile.exists()) {
      if (mounted) setState(() => _thumbPath = cachePath);
      return;
    }
    try {
      final thumb = await VideoThumbnail.thumbnailFile(
        video: widget.path,
        thumbnailPath: cachePath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
      );
      if (mounted && thumb != null) {
        setState(() => _thumbPath = thumb);
      }
    } catch (_) {}
  }

  Future<void> _loadDuration() async {
    try {
      final meta = await VideoThumbnail.getVideoMetadata(video: widget.path);
      if (mounted && meta != null) {
        setState(() => _durationMs = meta.durationMs);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbPath != null) {
      return Stack(
        children: [
          Image.file(
            File(_thumbPath!),
            width: widget.size,
            height: widget.size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _iconFallback(),
          ),
          if (_durationMs != null)
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  formatDurationMs(_durationMs!),
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          if (widget.onDelete != null)
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: () => widget.onDelete!(widget.path),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
        ],
      );
    }
    return _iconFallback();
  }

  Widget _iconFallback() {
    final iconData = fileIcon(widget.path);
    final color = fileColor(widget.path);
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(child: Icon(iconData, size: 40, color: color)),
          if (widget.onDelete != null)
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: () => widget.onDelete!(widget.path),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
