import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/note.dart';
import '../../../core/providers/repository_providers.dart';
import '../../settings/providers/settings_provider.dart';

part 'note_list_provider.g.dart';

bool _sortAscending(SortMode mode) {
  return switch (mode) {
    SortMode.dateDesc => false,
    SortMode.dateAsc => true,
  };
}

@riverpod
class NoteList extends _$NoteList {
  @override
  Future<List<Note>> build({String? searchQuery, String? tagFilter}) async {
    final sortMode = ref.watch(sortModeProvider);
    final repo = ref.watch(noteRepositoryProvider);
    return repo.getAll(
      searchQuery: searchQuery,
      tagFilter: tagFilter,
      sortBy: 'updated_at',
      ascending: _sortAscending(sortMode),
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
