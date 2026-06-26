import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import '../../data/models/note.dart';
import '../../l10n/app_localizations.dart';
import 'date_formatter.dart';

class ExportHelper {
  static String notesToMarkdown(List<Note> notes, AppLocalizations l10n, [String? locale]) {
    final md = StringBuffer();
    md.writeln('# ${l10n.exportTitle}');
    md.writeln(l10n.exportDate(DateFormat('dd.MM.yyyy HH:mm', locale).format(DateTime.now())));
    md.writeln();

    for (final note in notes) {
      md.writeln('---');
      md.writeln();
      md.writeln('## ${l10n.noteFrom(DateFormatter.formatAbsoluteWithWeekday(note.createdAt, locale))}');
      if (note.latitude != null && note.longitude != null) {
        md.writeln('📍 ${DateFormatter.formatDMS(note.latitude!, note.longitude!)}');
      }
      if (note.tags.isNotEmpty) {
        md.writeln('🏷 ${note.tags.map((t) => '#$t').join(' ')}');
      }
      md.writeln();
      if (note.text != null && note.text!.isNotEmpty) {
        md.writeln(note.text);
        md.writeln();
      }
      final noteFiles = [
        ...note.imagePaths,
        ...note.audioPaths,
        ...note.videoPaths,
        ...note.filePaths,
      ];
      if (noteFiles.isNotEmpty) {
        md.writeln('**${l10n.attachedFiles}:**');
        for (final p in noteFiles) {
          md.writeln('- ${p.split('/').last}');
        }
        md.writeln();
      }
    }

    return md.toString();
  }

  static String notesToJson(List<Note> notes) {
    final list = notes.map((note) {
      final noteFiles = [
        ...note.imagePaths,
        ...note.audioPaths,
        ...note.videoPaths,
        ...note.filePaths,
      ];
      return {
        'id': note.id,
        'created_at': DateFormat('yyyy-MM-ddTHH:mm:ss').format(note.createdAt),
        if (note.latitude != null && note.longitude != null)
          'latitude': note.latitude,
        if (note.latitude != null && note.longitude != null)
          'longitude': note.longitude,
        'tags': note.tags,
        'text': note.text,
        'files': noteFiles.map((p) => p.split('/').last).toList(),
      };
    }).toList();

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(list);
  }

  static Future<String> createZip(String zipPath, List<String> filePaths) async {
    final archive = Archive();

    for (final filePath in filePaths) {
      final file = File(filePath);
      if (!await file.exists()) continue;
      final bytes = await file.readAsBytes();
      final arcPath = p.basename(filePath);
      archive.addFile(ArchiveFile(arcPath, bytes.length, bytes));
    }

    final zipBytes = ZipEncoder().encode(archive);
    if (zipBytes == null) throw Exception('Failed to create ZIP archive');

    final zipFile = File(zipPath);
    await zipFile.writeAsBytes(zipBytes);
    return zipPath;
  }
}
