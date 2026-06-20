import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/note.dart';
import '../../../core/providers/repository_providers.dart';

part 'note_detail_provider.g.dart';

@riverpod
class NoteDetail extends _$NoteDetail {
  @override
  Future<Note?> build(int noteId) async {
    if (noteId <= 0) return null;
    final repo = ref.watch(noteRepositoryProvider);
    return repo.getById(noteId);
  }

  Future<void> save(Note note) async {
    final repo = ref.read(noteRepositoryProvider);
    if (note.id == null) {
      await repo.insert(note);
    } else {
      await repo.update(note);
    }
    ref.invalidateSelf();
  }

  Future<void> delete(int noteId) async {
    final repo = ref.read(noteRepositoryProvider);
    await repo.delete(noteId);
  }
}
