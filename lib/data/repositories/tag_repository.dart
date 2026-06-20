import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/tag.dart';
import 'note_repository.dart';

class TagRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final NoteRepository _noteRepo;

  TagRepository({NoteRepository? noteRepo}) : _noteRepo = noteRepo ?? NoteRepository();

  Future<List<Tag>> getAll() async {
    await rebuildCounts();
    final db = await _dbHelper.database;
    final maps = await db.query(
      TableTags.tableName,
      orderBy: '${TableTags.usageCount} DESC, ${TableTags.name} ASC',
    );
    return maps.map((m) => Tag.fromMap(m)).toList();
  }

  Future<int> insert(String name) async {
    final db = await _dbHelper.database;
    return db.insert(TableTags.tableName, {
      TableTags.name: name,
      TableTags.usageCount: 0,
    });
  }

  Future<int> update(Tag tag) async {
    final db = await _dbHelper.database;

    final oldMaps = await db.query(
      TableTags.tableName,
      where: '${TableTags.id} = ?',
      whereArgs: [tag.id],
    );
    if (oldMaps.isEmpty) return 0;
    final oldName = oldMaps.first[TableTags.name] as String;

    if (oldName == tag.name) return 0;

    // Replace old tag name with new name directly in notes' JSON tags
    await db.execute(
      "UPDATE ${TableNotes.tableName} SET ${TableNotes.tags} = REPLACE(${TableNotes.tags}, ?, ?) WHERE ${TableNotes.tags} LIKE ?",
      ['"$oldName"', '"${tag.name}"', '%"$oldName"%'],
    );

    // Rename the tag in tags table (usage count stays unchanged)
    await db.update(
      TableTags.tableName,
      {TableTags.name: tag.name},
      where: '${TableTags.id} = ?',
      whereArgs: [tag.id],
    );

    await rebuildCounts();

    return 1;
  }

  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      TableTags.tableName,
      where: '${TableTags.id} = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return;
    final tag = Tag.fromMap(maps.first);

    await db.delete(
      TableTags.tableName,
      where: '${TableTags.id} = ?',
      whereArgs: [id],
    );

    final notes = await _noteRepo.getByTag(tag.name);
    for (final note in notes) {
      final updatedTags = note.tags.where((t) => t != tag.name).toList();
      await _noteRepo.update(note.copyWith(tags: updatedTags));
    }
  }

  Future<List<String>> searchNames(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      TableTags.tableName,
      where: '${TableTags.name} LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '${TableTags.usageCount} DESC',
      limit: 10,
    );
    return maps.map((m) => m[TableTags.name] as String).toList();
  }

  Future<void> rebuildCounts() async {
    final db = await _dbHelper.database;
    await db.execute('''
      UPDATE ${TableTags.tableName}
      SET ${TableTags.usageCount} = (
        SELECT COUNT(*) FROM ${TableNotes.tableName}
        WHERE ${TableNotes.tags} LIKE '%"' || ${TableTags.tableName}.${TableTags.name} || '"%'
      )
    ''');
  }
}
