import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/note.dart';
import '../../../data/repositories/note_repository.dart';

part 'note_detail_provider.g.dart';

@riverpod
class NoteDetail extends _$NoteDetail {
  @override
  Future<Note?> build(int noteId) async {
    if (noteId <= 0) return null;
    final repo = NoteRepository();
    return repo.getById(noteId);
  }

  Future<void> save(Note note) async {
    final repo = NoteRepository();
    if (note.id == null) {
      await repo.insert(note);
    } else {
      await repo.update(note);
    }
    ref.invalidateSelf();
  }

  Future<void> delete(int noteId) async {
    final repo = NoteRepository();
    await repo.delete(noteId);
  }
}
