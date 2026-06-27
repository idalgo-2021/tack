import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:video_thumbnail_gen/video_thumbnail_gen.dart';
import '../../../core/utils/file_type_icons.dart';
import '../../../core/widgets/file_context_menu.dart';

const _maxPreviewSize = 50 * 1024;

class ThumbnailPreview {
  static Future<void> show(BuildContext context, List<String> filePaths, {int initialIndex = 0}) {
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      barrierDismissible: true,
      builder: (ctx) => _ThumbnailPreviewContent(filePaths: filePaths, initialIndex: initialIndex),
    );
  }
}

class _ThumbnailPreviewContent extends StatefulWidget {
  final List<String> filePaths;
  final int initialIndex;

  const _ThumbnailPreviewContent({required this.filePaths, required this.initialIndex});

  @override
  State<_ThumbnailPreviewContent> createState() => _ThumbnailPreviewContentState();
}

class _ThumbnailPreviewContentState extends State<_ThumbnailPreviewContent> {
  late int _currentIndex;
  late String _currentPath;

  String? _thumbPath;
  int? _durationMs;
  String? _textContent;
  int? _fileSize;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.filePaths.length - 1);
    _currentPath = widget.filePaths[_currentIndex];
    _loadCurrent();
  }

  void _navigate(int delta) {
    final next = (_currentIndex + delta).clamp(0, widget.filePaths.length - 1);
    if (next == _currentIndex) return;
    setState(() {
      _currentIndex = next;
      _currentPath = widget.filePaths[next];
      _thumbPath = null;
      _durationMs = null;
      _textContent = null;
      _fileSize = null;
      _isLoading = true;
    });
    _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    final file = File(_currentPath);
    try {
      final size = await file.length();
      if (!mounted) return;
      _fileSize = size;
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    if (isImageFile(_currentPath)) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    if (isVideoFile(_currentPath)) {
      await _loadVideoContent();
      return;
    }

    if (isTextFile(_currentPath) && _fileSize != null && _fileSize! <= _maxPreviewSize) {
      await _loadTextContent();
      return;
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadVideoContent() async {
    await Future.wait([_loadThumbnail(), _loadDuration()]);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadThumbnail() async {
    final cachePath = '${_currentPath}_thumb.jpg';
    final cacheFile = File(cachePath);
    if (await cacheFile.exists()) {
      if (mounted) setState(() => _thumbPath = cachePath);
      return;
    }
    try {
      final thumb = await VideoThumbnail.thumbnailFile(
        video: _currentPath,
        thumbnailPath: cachePath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 600,
        quality: 80,
      );
      if (mounted && thumb != null) {
        setState(() => _thumbPath = thumb);
      }
    } catch (_) {}
  }

  Future<void> _loadDuration() async {
    try {
      final meta = await VideoThumbnail.getVideoMetadata(video: _currentPath);
      if (mounted && meta != null) {
        setState(() => _durationMs = meta.durationMs);
      }
    } catch (_) {}
  }

  Future<void> _loadTextContent() async {
    try {
      final content = await File(_currentPath).readAsString();
      if (mounted) {
        setState(() {
          _textContent = content;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
          GestureDetector(
            onLongPress: () => _showContextMenu(context),
            child: _buildPreviewContent(),
          ),
          Positioned(
            top: topPadding + 8,
            left: 8,
            child: MenuAnchor(
              builder: (context, controller, child) => IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              ),
              menuChildren: FileContextMenu.buildMenuItems(context, _currentPath),
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
          if (widget.filePaths.length > 1) _buildNavigation(),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    } else if (isImageFile(_currentPath)) {
      final mq = MediaQuery.of(context);
      final cacheWidth = (mq.size.width * mq.devicePixelRatio).round();
      return InteractiveViewer(
        child: Center(
          child: Image.file(
            File(_currentPath),
            fit: BoxFit.contain,
            cacheWidth: cacheWidth,
            errorBuilder: (_, _, _) => const Icon(
              Icons.broken_image,
              size: 80,
              color: Colors.white54,
            ),
          ),
        ),
      );
    } else if (isVideoFile(_currentPath)) {
      return _videoPreview();
    } else if (isTextFile(_currentPath) && _textContent != null) {
      return _textPreview();
    } else {
      return _fallbackPreview();
    }
  }

  void _showContextMenu(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final anchorRect = Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(anchorRect, Offset.zero & MediaQuery.of(context).size),
      items: FileContextMenu.buildMenuItems(context, _currentPath),
    );
  }

  Widget _buildNavigation() {
    return Stack(
      children: [
        Positioned(
          left: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: _currentIndex > 0
                ? IconButton.filledTonal(
                    icon: const Icon(Icons.chevron_left, size: 36, color: Colors.white),
                    onPressed: () => _navigate(-1),
                    style: IconButton.styleFrom(backgroundColor: Colors.black54),
                  )
                : const SizedBox(),
          ),
        ),
        Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: _currentIndex < widget.filePaths.length - 1
                ? IconButton.filledTonal(
                    icon: const Icon(Icons.chevron_right, size: 36, color: Colors.white),
                    onPressed: () => _navigate(1),
                    style: IconButton.styleFrom(backgroundColor: Colors.black54),
                  )
                : const SizedBox(),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 48),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${widget.filePaths.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(width: 16),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ],
    );
  }

  Widget _videoPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_thumbPath != null)
          Builder(
            builder: (context) {
              final mq = MediaQuery.of(context);
              final cacheWidth = (mq.size.width * mq.devicePixelRatio).round();
              return Center(
                child: Image.file(
                  File(_thumbPath!),
                  fit: BoxFit.contain,
                  cacheWidth: cacheWidth,
                  errorBuilder: (_, _, _) => _videoPlaceholder(),
                ),
              );
            },
          )
        else
          _videoPlaceholder(),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              OpenFilex.open(_currentPath);
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: const Icon(Icons.play_arrow, size: 64, color: Colors.white),
            ),
          ),
        ),
        if (_durationMs != null)
          Positioned(
            bottom: 24,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                formatDurationMs(_durationMs!),
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ],
    );
  }

  Widget _videoPlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.video_file, size: 100, color: Colors.white70),
          const SizedBox(height: 16),
          Text(
            _currentPath.split('/').last,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _textPreview() {
    return InteractiveViewer(
      constrained: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 80),
        child: SelectableText(
          _textContent!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'monospace',
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _fallbackPreview() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isTextFile(_currentPath) && _fileSize != null && _fileSize! > _maxPreviewSize
              ? Icons.description
              : fileIcon(_currentPath),
              size: 100, color: Colors.white70),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _currentPath.split('/').last,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          if (isTextFile(_currentPath) && _fileSize != null && _fileSize! > _maxPreviewSize) ...[
            const SizedBox(height: 8),
            const Text(
              'File too large for preview',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
