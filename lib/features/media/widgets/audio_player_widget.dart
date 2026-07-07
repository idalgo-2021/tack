import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final VoidCallback? onDelete;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    this.onDelete,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _hasError = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadSource(widget.audioPath);
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  Future<void> _loadSource(String path) async {
    if (!File(path).existsSync()) {
      debugPrint('AUDIO FILE NOT FOUND: $path');
      if (mounted) setState(() => _hasError = true);
      return;
    }
    try {
      await _player.setSource(DeviceFileSource(path));
      if (mounted) setState(() => _hasError = false);
    } catch (e) {
      debugPrint('AudioPlayerWidget setSource error: $e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioPath != widget.audioPath) {
      _player.stop();
      _position = Duration.zero;
      _isPlaying = false;
      _loadSource(widget.audioPath);
    }
  }

  void _togglePlay() async {
    if (_hasError) return;
    if (_isPlaying) {
      await _player.pause();
    } else {
      try {
        if (_position == Duration.zero || _position == _duration) {
          await _player.resume();
          if (_position == _duration) {
            await _player.seek(Duration.zero);
          }
        } else {
          await _player.resume();
        }
      } catch (e) {
        debugPrint('AudioPlayerWidget play error: $e');
        if (mounted) setState(() => _hasError = true);
      }
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_hasError) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ошибка загрузки аудио',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              if (widget.onDelete != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: widget.onDelete,
                ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
              color: theme.colorScheme.primary,
              onPressed: _togglePlay,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.audioPath.split('/').last,
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: _duration.inMilliseconds > 0
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.onDelete != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: widget.onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
