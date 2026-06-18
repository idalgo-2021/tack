import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/utils/file_type_icons.dart';

class ThumbnailPreview {
  static Future<void> show(BuildContext context, String path, {required bool isImage}) {
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      barrierDismissible: true,
      builder: (ctx) => _ThumbnailPreviewContent(path: path, isImage: isImage),
    );
  }
}

class _ThumbnailPreviewContent extends StatelessWidget {
  final String path;
  final bool isImage;

  const _ThumbnailPreviewContent({required this.path, required this.isImage});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isImage)
            InteractiveViewer(
              child: Center(
                child: Image.file(
                  File(path),
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.white54,
                  ),
                ),
              ),
            )
          else
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(fileIcon(path), size: 100, color: Colors.white70),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      path.split('/').last,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          Positioned(
            top: topPadding + 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
