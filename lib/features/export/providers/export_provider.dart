import 'dart:io';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/utils/export_helper.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/providers/settings_provider.dart';

part 'export_provider.g.dart';

class ExportState {
  final bool isExporting;
  final String? exportPath;
  final String? error;

  const ExportState({
    this.isExporting = false,
    this.exportPath,
    this.error,
  });
}

@riverpod
class Export extends _$Export {
  @override
  ExportState build() => const ExportState();

  Future<void> exportAll(AppLocalizations l10n) async {
    state = const ExportState(isExporting: true);

    try {
      final repo = ref.read(noteRepositoryProvider);
      final notes = await repo.getAll();

      if (notes.isEmpty) {
        state = ExportState(error: l10n.exportNoNotes);
        return;
      }

      final format = ref.read(exportFormatProvider);
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final ext = format == ExportFormat.markdown ? 'md' : 'json';
      final content = format == ExportFormat.markdown
          ? ExportHelper.notesToMarkdown(notes, l10n)
          : ExportHelper.notesToJson(notes);
      final contentFile = File('${Directory.systemTemp.path}/tack_$timestamp.$ext');
      await contentFile.writeAsString(content);

      final allPaths = <String>[contentFile.path];
      for (final note in notes) {
        for (final p in note.imagePaths) {
          if (await File(p).exists()) allPaths.add(p);
        }
        for (final p in note.audioPaths) {
          if (await File(p).exists()) allPaths.add(p);
        }
        for (final p in note.videoPaths) {
          if (await File(p).exists()) allPaths.add(p);
        }
        for (final p in note.filePaths) {
          if (await File(p).exists()) allPaths.add(p);
        }
      }

      final zipPath = '${Directory.systemTemp.path}/tack_$timestamp.zip';
      await ExportHelper.createZip(zipPath, allPaths);

      state = ExportState(exportPath: zipPath);

      await SharePlus.instance.share(
        ShareParams(files: [XFile(zipPath)]),
      );
    } catch (e) {
      state = ExportState(error: l10n.exportError(e.toString()));
    }
  }

  void reset() {
    state = const ExportState();
  }
}
