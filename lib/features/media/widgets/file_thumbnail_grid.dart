import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/utils/file_type_icons.dart';
import 'thumbnail_preview.dart';

class FileThumbnailGrid extends StatelessWidget {
  final List<String> filePaths;
  final ValueChanged<String>? onDelete;

  const FileThumbnailGrid({
    super.key,
    required this.filePaths,
    this.onDelete,
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

    return GestureDetector(
      onTap: () => ThumbnailPreview.show(context, path, isImage: isImageFile(path)),
      child: SizedBox(
        width: size,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isImageFile(path)
                  ? _imageThumbnail(path, size, theme)
                  : _iconTile(path, size, theme),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
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
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () => onDelete!(path),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _iconTile(String path, double size, ThemeData theme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fileColor(path).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(fileIcon(path), size: 40, color: fileColor(path)),
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
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
