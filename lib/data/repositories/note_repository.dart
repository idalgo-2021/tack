import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/note.dart';

class NoteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insert(Note note) async {
    final db = await _dbHelper.database;
    final id = await db.insert(TableNotes.tableName, note.toMap());
    await _syncTags(note.tags);
    return id;
  }

  Future<int> update(Note note) async {
    final db = await _dbHelper.database;
    final oldNote = await getById(note.id!);
    final result = await db.update(
      TableNotes.tableName,
      note.toMap(),
      where: '${TableNotes.id} = ?',
      whereArgs: [note.id],
    );
    if (oldNote != null) {
      await _syncTagsForUpdate(oldNote.tags, note.tags);
    } else {
      await _syncTags(note.tags);
    }
    return result;
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    final note = await getById(id);
    final result = await db.delete(
      TableNotes.tableName,
      where: '${TableNotes.id} = ?',
      whereArgs: [id],
    );
    if (note != null) {
      await _decrementTags(note.tags);
    }
    return result;
  }

  Future<Note?> getById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      TableNotes.tableName,
      where: '${TableNotes.id} = ?',
      whereArgs: [id],
      limit: 1,
    );
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
    String sortBy = 'created_at',
    bool ascending = false,
  }) async {
    final db = await _dbHelper.database;
    final where = <String>[];
    final whereArgs = <dynamic>[];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      where.add('${TableNotes.text} LIKE ?');
      whereArgs.add('%$searchQuery%');
    }

    if (tagFilter != null && tagFilter.isNotEmpty) {
      where.add('${TableNotes.tags} LIKE ?');
      whereArgs.add('%"$tagFilter"%');
    }

    if (dateFrom != null) {
      where.add('${TableNotes.createdAt} >= ?');
      whereArgs.add(dateFrom.millisecondsSinceEpoch);
    }

    if (dateTo != null) {
      where.add('${TableNotes.createdAt} <= ?');
      whereArgs.add(dateTo.millisecondsSinceEpoch);
    }

    if (hasImages == true) {
      where.add('${TableNotes.imagePaths} != \'[]\'');
    }
    if (hasAudio == true) {
      where.add('${TableNotes.audioPaths} != \'[]\'');
    }
    if (hasFiles == true) {
      where.add('${TableNotes.filePaths} != \'[]\'');
    }
    if (hasVideos == true) {
      where.add('${TableNotes.videoPaths} != \'[]\'');
    }

    final maps = await db.query(
      TableNotes.tableName,
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: '$sortBy ${ascending ? 'ASC' : 'DESC'}',
    );
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<List<Note>> getByTag(String tag, {String sortBy = 'created_at', bool ascending = false}) async {
    return getAll(tagFilter: tag, sortBy: sortBy, ascending: ascending);
  }

  Future<void> _syncTags(List<String> tags) async {
    final db = await _dbHelper.database;
    for (final tag in tags) {
      final existing = await db.query(
        TableTags.tableName,
        where: '${TableTags.name} = ?',
        whereArgs: [tag],
      );
      if (existing.isEmpty) {
        await db.insert(TableTags.tableName, {
          TableTags.name: tag,
          TableTags.usageCount: 1,
        });
      } else {
        await db.update(
          TableTags.tableName,
          {TableTags.usageCount: (existing.first[TableTags.usageCount] as int) + 1},
          where: '${TableTags.name} = ?',
          whereArgs: [tag],
        );
      }
    }
  }

  Future<void> _syncTagsForUpdate(List<String> oldTags, List<String> newTags) async {
    final removed = oldTags.where((t) => !newTags.contains(t)).toList();
    final added = newTags.where((t) => !oldTags.contains(t)).toList();
    if (removed.isNotEmpty) await _decrementTags(removed);
    if (added.isNotEmpty) await _syncTags(added);
  }

  Future<void> _decrementTags(List<String> tags) async {
    final db = await _dbHelper.database;
    for (final tag in tags) {
      final existing = await db.query(
        TableTags.tableName,
        where: '${TableTags.name} = ?',
        whereArgs: [tag],
      );
      if (existing.isNotEmpty) {
        final count = (existing.first[TableTags.usageCount] as int) - 1;
        await db.update(
          TableTags.tableName,
          {TableTags.usageCount: count < 0 ? 0 : count},
          where: '${TableTags.name} = ?',
          whereArgs: [tag],
        );
      }
    }
  }
}
