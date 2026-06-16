import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/media_provider.dart';

class AudioRecorderWidget extends ConsumerWidget {
  final VoidCallback onRecordingComplete;

  const AudioRecorderWidget({super.key, required this.onRecordingComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(mediaRecorderProvider);
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isRecording ? Icons.mic : Icons.mic_none,
          color: isRecording ? Colors.red : theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        if (isRecording)
          Text('Запись...', style: TextStyle(color: Colors.red))
        else
          const Text('Записать аудио'),
        if (isRecording) ...[
          const SizedBox(width: 8),
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ],
    );
  }
}

class AudioRecordButton extends ConsumerWidget {
  final VoidCallback onRecorded;

  const AudioRecordButton({super.key, required this.onRecorded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(mediaRecorderProvider);

    return OutlinedButton.icon(
      onPressed: () async {
        final notifier = ref.read(mediaRecorderProvider.notifier);
        if (isRecording) {
          await notifier.stopRecording();
          onRecorded();
        } else {
          await notifier.startRecording();
        }
      },
      icon: Icon(
        isRecording ? Icons.stop : Icons.mic,
        color: isRecording ? Colors.red : null,
      ),
      label: Text(isRecording ? 'Остановить' : 'Аудио'),
    );
  }
}
