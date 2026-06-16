import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'tack.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        for (final query in DatabaseSchema.v1Queries) {
          await db.execute(query);
        }
        await db.execute(DatabaseSchema.addFilePathsColumn);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(DatabaseSchema.addFilePathsColumn);
        }
      },
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
