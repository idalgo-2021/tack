import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/database_helper.dart';
import '../../data/repositories/note_repository.dart';
import '../../data/repositories/tag_repository.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((_) {
  return DatabaseHelper.instance;
});

final noteRepositoryProvider = Provider<NoteRepository>((_) {
  return NoteRepository();
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return TagRepository(noteRepo: ref.watch(noteRepositoryProvider));
});
