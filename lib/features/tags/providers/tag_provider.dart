import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/tag.dart';
import '../../../core/providers/repository_providers.dart';
import '../../notes/providers/note_list_provider.dart';

part 'tag_provider.g.dart';

@riverpod
class TagList extends _$TagList {
  @override
  Future<List<Tag>> build() async {
    final repo = ref.watch(tagRepositoryProvider);
    return repo.getAll();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> add(String name) async {
    final repo = ref.read(tagRepositoryProvider);
    await repo.insert(name);
    ref.invalidateSelf();
  }

  Future<void> rename(int id, String newName) async {
    final repo = ref.read(tagRepositoryProvider);
    await repo.update(Tag(id: id, name: newName));
    ref.invalidate(noteListProvider);
    ref.invalidateSelf();
  }

  Future<void> delete(int id) async {
    final repo = ref.read(tagRepositoryProvider);
    await repo.delete(id);
    ref.invalidate(noteListProvider);
    ref.invalidateSelf();
  }
}
