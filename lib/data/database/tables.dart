class TableNotes {
  static const tableName = 'notes';
  static const id = 'id';
  static const text = 'text';
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

class TableNoteTags {
  static const tableName = 'note_tags';
  static const noteId = 'note_id';
  static const tagId = 'tag_id';
}

class DatabaseSchema {
  static const createNotesTableV1 = '''
    CREATE TABLE ${TableNotes.tableName} (
      ${TableNotes.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${TableNotes.text} TEXT,
      ${TableNotes.imagePaths} TEXT DEFAULT '[]',
      ${TableNotes.audioPaths} TEXT DEFAULT '[]',
      ${TableNotes.filePaths} TEXT DEFAULT '[]',
      ${TableNotes.videoPaths} TEXT DEFAULT '[]',
      ${TableNotes.createdAt} INTEGER NOT NULL,
      ${TableNotes.latitude} REAL,
      ${TableNotes.longitude} REAL,
      ${TableNotes.color} INTEGER
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

  static const createNoteTagsTable = '''
    CREATE TABLE ${TableNoteTags.tableName} (
      ${TableNoteTags.noteId} INTEGER NOT NULL REFERENCES ${TableNotes.tableName}(${TableNotes.id}) ON DELETE CASCADE,
      ${TableNoteTags.tagId} INTEGER NOT NULL REFERENCES ${TableTags.tableName}(${TableTags.id}) ON DELETE CASCADE,
      PRIMARY KEY (${TableNoteTags.noteId}, ${TableNoteTags.tagId})
    )
  ''';

  static const createNoteTagsTagIndex = '''
    CREATE INDEX idx_note_tags_tag ON ${TableNoteTags.tableName}(${TableNoteTags.tagId})
  ''';

  static const createNoteTagsNoteIndex = '''
    CREATE INDEX idx_note_tags_note ON ${TableNoteTags.tableName}(${TableNoteTags.noteId})
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
    createNoteTagsTable,
    createNoteTagsTagIndex,
    createNoteTagsNoteIndex,
    createNotesCreatedAtIndex,
    createTagsNameIndex,
  ];
}
