class TableNotes {
  static const tableName = 'notes';
  static const id = 'id';
  static const text = 'text';
  static const tags = 'tags';
  static const imagePaths = 'image_paths';
  static const audioPaths = 'audio_paths';
  static const filePaths = 'file_paths';
  static const videoPaths = 'video_paths';
  static const createdAt = 'created_at';
  static const latitude = 'latitude';
  static const longitude = 'longitude';
  static const color = 'color';
}

class TableTags {
  static const tableName = 'tags';
  static const id = 'id';
  static const name = 'name';
  static const usageCount = 'usage_count';
}

class DatabaseSchema {
  static const createNotesTableV1 = '''
    CREATE TABLE ${TableNotes.tableName} (
      ${TableNotes.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${TableNotes.text} TEXT,
      ${TableNotes.tags} TEXT DEFAULT '[]',
      ${TableNotes.imagePaths} TEXT DEFAULT '[]',
      ${TableNotes.audioPaths} TEXT DEFAULT '[]',
      ${TableNotes.createdAt} INTEGER NOT NULL,
      ${TableNotes.latitude} REAL,
      ${TableNotes.longitude} REAL
    )
  ''';

  static const addFilePathsColumn = '''
    ALTER TABLE ${TableNotes.tableName}
    ADD COLUMN ${TableNotes.filePaths} TEXT DEFAULT '[]'
  ''';

  static const addVideoPathsColumn = '''
    ALTER TABLE ${TableNotes.tableName}
    ADD COLUMN ${TableNotes.videoPaths} TEXT DEFAULT '[]'
  ''';

  static const createTagsTable = '''
    CREATE TABLE ${TableTags.tableName} (
      ${TableTags.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${TableTags.name} TEXT NOT NULL UNIQUE,
      ${TableTags.usageCount} INTEGER DEFAULT 0
    )
  ''';

  static const createNotesCreatedAtIndex = '''
    CREATE INDEX idx_notes_created_at ON ${TableNotes.tableName}(${TableNotes.createdAt} DESC)
  ''';

  static const createTagsNameIndex = '''
    CREATE INDEX idx_tags_name ON ${TableTags.tableName}(${TableTags.name})
  ''';

  static const addColorColumn = '''
    ALTER TABLE ${TableNotes.tableName}
    ADD COLUMN ${TableNotes.color} INTEGER
  ''';

  static const v1Queries = [
    createNotesTableV1,
    createTagsTable,
    createNotesCreatedAtIndex,
    createTagsNameIndex,
  ];
}
