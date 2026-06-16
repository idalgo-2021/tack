import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/export_helper.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/repositories/note_repository.dart';
import '../providers/note_detail_provider.dart';
import '../providers/note_list_provider.dart';
import 'note_editor_screen.dart';
import '../../media/widgets/audio_player_widget.dart';
import '../../media/widgets/image_grid_widget.dart';
import '../../settings/providers/settings_provider.dart';

class NoteDetailScreen extends ConsumerWidget {
  final int noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final noteAsync = ref.watch(noteDetailProvider(noteId));
    final showTs = ref.watch(showTimestampProvider);
    final theme = Theme.of(context);

    return noteAsync.when(
      data: (note) {
        if (note == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.article_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(l10n.noteNotFound, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(l10n.noteDeleted, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          );
        }

        final hasLocation = note.latitude != null && note.longitude != null;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.editNote),
            actions: [
              if (note.text != null && note.text!.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: note.text!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.textCopied)),
                    );
                  },
                ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareNote(note, ref, context),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoteEditorScreen(existingNoteId: noteId),
                    ),
                  );
                  ref.invalidate(noteDetailProvider(noteId));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (showTs)
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Text(
                            DateFormatter.formatAbsoluteWithWeekday(note.createdAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    if (showTs && hasLocation) const SizedBox(width: 16),
                    if (hasLocation)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, size: 14, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.formatDMS(note.latitude!, note.longitude!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                if (note.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: note.tags.map((tag) => Chip(
                      label: Text('#$tag', style: const TextStyle(fontSize: 12)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    )).toList(),
                  ),
                ],
                if (note.text != null && note.text!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SelectableText(note.text!, style: theme.textTheme.bodyLarge),
                ],
                if (note.imagePaths.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ImageGridWidget(imagePaths: note.imagePaths),
                ],
                if (note.audioPaths.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(l10n.audio, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ...note.audioPaths.map((path) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AudioPlayerWidget(audioPath: path),
                  )),
                ],
                if (note.filePaths.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(l10n.files, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ...note.filePaths.map((path) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      dense: true,
                      leading: const Icon(Icons.attach_file),
                      title: Text(path.split('/').last, style: const TextStyle(fontSize: 13)),
                    ),
                  )),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('${l10n.error}: $error')),
      ),
    );
  }

  Future<void> _shareNote(dynamic note, WidgetRef ref, BuildContext context) async {
    final format = ref.read(exportFormatProvider);
    final zip = ref.read(zipExportProvider);
    final timestamp = DateFormatter.formatFileDate(note.createdAt);
    final allFiles = <XFile>[];

    if (format == ExportFormat.markdown) {
      final content = ExportHelper.notesToMarkdown([note]);
      final file = File('${Directory.systemTemp.path}/smart_note_$timestamp.md');
      await file.writeAsString(content);
      allFiles.add(XFile(file.path));
    } else {
      final content = ExportHelper.notesToJson([note]);
      final file = File('${Directory.systemTemp.path}/smart_note_$timestamp.json');
      await file.writeAsString(content);
      allFiles.add(XFile(file.path));
    }

    if (zip) {
      final attachPaths = <String>[allFiles.first.path];
      for (final p in note.imagePaths) { attachPaths.add(p); }
      for (final p in note.audioPaths) { attachPaths.add(p); }
      for (final p in note.filePaths) { attachPaths.add(p); }
      final zipPath = '${Directory.systemTemp.path}/smart_note_$timestamp.zip';
      await ExportHelper.createZip(zipPath, attachPaths);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(zipPath)]),
      );
    } else {
      for (final p in note.imagePaths) { allFiles.add(XFile(p)); }
      for (final p in note.audioPaths) { allFiles.add(XFile(p)); }
      for (final p in note.filePaths) { allFiles.add(XFile(p)); }
      await SharePlus.instance.share(
        ShareParams(files: allFiles),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteNote),
        content: Text(l10n.deleteConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed != true) return;

    final repo = NoteRepository();
    await repo.delete(noteId);

    if (context.mounted) {
      ref.invalidate(noteListProvider);
      Navigator.pop(context);
    }
  }
}
