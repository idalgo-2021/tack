import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/note.dart';
import '../../core/utils/file_utils.dart';

class NoteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Note>> getByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final db = await _dbHelper.database;
    final placeholders = ids.map((_) => '?').join(',');
    final maps = await db.rawQuery('''
      SELECT n.*, GROUP_CONCAT(t.name) AS tag_names
      FROM ${TableNotes.tableName} n
      LEFT JOIN ${TableNoteTags.tableName} nt ON n.${TableNotes.id} = nt.${TableNoteTags.noteId}
      LEFT JOIN ${TableTags.tableName} t ON nt.${TableNoteTags.tagId} = t.${TableTags.id}
      WHERE n.${TableNotes.id} IN ($placeholders)
      GROUP BY n.${TableNotes.id}
    ''', ids);
    final notes = maps.map((m) => Note.fromMap(m)).toList();
    return Future.wait(notes.map(_sanitizeNote));
  }

  Future<void> togglePinMany(List<int> ids) async {
    if (ids.isEmpty) return;
    final db = await _dbHelper.database;
    final placeholders = ids.map((_) => '?').join(',');
    await db.rawUpdate('''
      UPDATE ${TableNotes.tableName}
      SET ${TableNotes.isPinned} = NOT ${TableNotes.isPinned}
      WHERE ${TableNotes.id} IN ($placeholders)
    ''', ids);
  }

  Future<void> deleteMany(List<int> ids) async {
    if (ids.isEmpty) return;
    final db = await _dbHelper.database;
    final placeholders = ids.map((_) => '?').join(',');
    await db.transaction((txn) async {
      await txn.delete(
        TableNoteTags.tableName,
        where: '${TableNoteTags.noteId} IN ($placeholders)',
        whereArgs: ids,
      );
      await txn.delete(
        TableNotes.tableName,
        where: '${TableNotes.id} IN ($placeholders)',
        whereArgs: ids,
      );
    });
  }

  Future<int> insert(Note note) async {
    final db = await _dbHelper.database;
    return db.transaction<int>((txn) async {
      final id = await txn.insert(TableNotes.tableName, note.toMap());
      await _syncTags(txn, id, note.tagNames);
      return id;
    });
  }

  Future<int> update(Note note) async {
    final db = await _dbHelper.database;
    return db.transaction<int>((txn) async {
      final result = await txn.update(
        TableNotes.tableName,
        note.toMap(),
        where: '${TableNotes.id} = ?',
        whereArgs: [note.id],
      );
      await txn.delete(
        TableNoteTags.tableName,
        where: '${TableNoteTags.noteId} = ?',
        whereArgs: [note.id],
      );
      await _syncTags(txn, note.id!, note.tagNames);
      return result;
    });
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      TableNotes.tableName,
      where: '${TableNotes.id} = ?',
      whereArgs: [id],
    );
  }

  Future<Note?> getById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT n.*, GROUP_CONCAT(t.name) AS tag_names
      FROM ${TableNotes.tableName} n
      LEFT JOIN ${TableNoteTags.tableName} nt ON n.${TableNotes.id} = nt.${TableNoteTags.noteId}
      LEFT JOIN ${TableTags.tableName} t ON nt.${TableNoteTags.tagId} = t.${TableTags.id}
      WHERE n.${TableNotes.id} = ?
      GROUP BY n.${TableNotes.id}
    ''', [id]);
    if (maps.isEmpty) return null;
    return Note.fromMap(maps.first);
  }

  Future<List<Note>> getAll({
    String? searchQuery,
    String? tagFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool? hasImages,
    bool? hasAudio,
    bool? hasFiles,
    bool? hasVideos,
    String sortBy = 'updated_at',
    bool ascending = false,
  }) async {
    final db = await _dbHelper.database;
    final where = <String>[];
    final whereArgs = <dynamic>[];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      where.add('n.${TableNotes.text} LIKE ?');
      whereArgs.add('%$searchQuery%');
    }

    if (tagFilter != null && tagFilter.isNotEmpty) {
      where.add('''n.${TableNotes.id} IN (
        SELECT nt2.${TableNoteTags.noteId}
        FROM ${TableNoteTags.tableName} nt2
        JOIN ${TableTags.tableName} t2 ON nt2.${TableNoteTags.tagId} = t2.${TableTags.id}
        WHERE t2.${TableTags.name} = ?
      )''');
      whereArgs.add(tagFilter);
    }

    if (dateFrom != null) {
      where.add('n.${TableNotes.createdAt} >= ?');
      whereArgs.add(dateFrom.millisecondsSinceEpoch);
    }

    if (dateTo != null) {
      where.add('n.${TableNotes.createdAt} <= ?');
      whereArgs.add(dateTo.millisecondsSinceEpoch);
    }

    if (hasImages == true) {
      where.add('n.${TableNotes.imagePaths} != \'[]\'');
    }
    if (hasAudio == true) {
      where.add('n.${TableNotes.audioPaths} != \'[]\'');
    }
    if (hasFiles == true) {
      where.add('n.${TableNotes.filePaths} != \'[]\'');
    }
    if (hasVideos == true) {
      where.add('n.${TableNotes.videoPaths} != \'[]\'');
    }

    final sql = '''
      SELECT n.*, GROUP_CONCAT(t.name) AS tag_names
      FROM ${TableNotes.tableName} n
      LEFT JOIN ${TableNoteTags.tableName} nt ON n.${TableNotes.id} = nt.${TableNoteTags.noteId}
      LEFT JOIN ${TableTags.tableName} t ON nt.${TableNoteTags.tagId} = t.${TableTags.id}
      ${where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : ''}
      GROUP BY n.${TableNotes.id}
      ORDER BY n.${TableNotes.isPinned} DESC, n.$sortBy ${ascending ? 'ASC' : 'DESC'}
    ''';

    final maps = await db.rawQuery(sql, whereArgs);
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<List<Note>> getByTag(String tag, {String sortBy = 'updated_at', bool ascending = false}) async {
    return getAll(tagFilter: tag, sortBy: sortBy, ascending: ascending);
  }

  Future<void> togglePin(int id) async {
    final db = await _dbHelper.database;
    await db.rawUpdate('''
      UPDATE ${TableNotes.tableName}
      SET ${TableNotes.isPinned} = NOT ${TableNotes.isPinned}
      WHERE ${TableNotes.id} = ?
    ''', [id]);
  }

  Future<void> _syncTags(Transaction txn, int noteId, List<String> tagNames) async {
    if (tagNames.isEmpty) return;

    final placeholders = tagNames.map((_) => '?').join(',');
    final existingMaps = await txn.query(
      TableTags.tableName,
      where: '${TableTags.name} IN ($placeholders)',
      whereArgs: tagNames,
    );
    final existing = {for (final m in existingMaps) m[TableTags.name] as String: m[TableTags.id] as int};

    for (final name in tagNames) {
      final tagId = existing[name] ?? await txn.insert(TableTags.tableName, {
        TableTags.name: name,
        TableTags.usageCount: 0,
      });
      await txn.insert(TableNoteTags.tableName, {
        TableNoteTags.noteId: noteId,
        TableNoteTags.tagId: tagId,
      });
    }
  }

  Future<Note> _sanitizeNote(Note note) async {
    final imagePaths = await _filterPaths(note.imagePaths);
    final audioPaths = await _filterPaths(note.audioPaths);
    final filePaths = await _filterPaths(note.filePaths);
    final videoPaths = await _filterPaths(note.videoPaths);
    return note.copyWith(
      imagePaths: imagePaths,
      audioPaths: audioPaths,
      filePaths: filePaths,
      videoPaths: videoPaths,
    );
  }

  Future<List<String>> _filterPaths(List<String> paths) async {
    final result = <String>[];
    for (final path in paths) {
      if (await FileUtils.isWithinAppDir(path)) {
        result.add(path);
      }
    }
    return result;
  }
}
