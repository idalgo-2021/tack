import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/tag.dart';

class TagRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Tag>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT t.${TableTags.id}, t.${TableTags.name}, COUNT(n.${TableNotes.id}) AS ${TableTags.usageCount}
      FROM ${TableTags.tableName} t
      LEFT JOIN ${TableNoteTags.tableName} nt ON t.${TableTags.id} = nt.${TableNoteTags.tagId}
      LEFT JOIN ${TableNotes.tableName} n ON nt.${TableNoteTags.noteId} = n.${TableNotes.id}
      GROUP BY t.${TableTags.id}
      ORDER BY ${TableTags.usageCount} DESC, t.${TableTags.name} ASC
    ''');
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
    return db.update(
      TableTags.tableName,
      {TableTags.name: tag.name},
      where: '${TableTags.id} = ?',
      whereArgs: [tag.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      TableTags.tableName,
      where: '${TableTags.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<String>> searchNames(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT t.${TableTags.id}, t.${TableTags.name}, COUNT(n.${TableNotes.id}) AS ${TableTags.usageCount}
      FROM ${TableTags.tableName} t
      LEFT JOIN ${TableNoteTags.tableName} nt ON t.${TableTags.id} = nt.${TableNoteTags.tagId}
      LEFT JOIN ${TableNotes.tableName} n ON nt.${TableNoteTags.noteId} = n.${TableNotes.id}
      WHERE t.${TableTags.name} LIKE ?
      GROUP BY t.${TableTags.id}
      ORDER BY ${TableTags.usageCount} DESC
      LIMIT 10
    ''', ['%$query%']);
    return maps.map((m) => m[TableTags.name] as String).toList();
  }
}
