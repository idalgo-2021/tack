import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/note.dart';
import '../../../data/repositories/note_repository.dart';
import '../../settings/providers/settings_provider.dart';

part 'note_list_provider.g.dart';

String _sortColumn(SortMode mode) {
  return 'created_at';
}

bool _sortAscending(SortMode mode) {
  switch (mode) {
    case SortMode.dateDesc:
      return false;
    case SortMode.dateAsc:
      return true;
  }
}

@riverpod
class NoteList extends _$NoteList {
  @override
  Future<List<Note>> build({String? searchQuery, String? tagFilter}) async {
    final sortMode = ref.watch(sortModeProvider);
    final repo = NoteRepository();
    return repo.getAll(
      searchQuery: searchQuery,
      tagFilter: tagFilter,
      sortBy: _sortColumn(sortMode),
      ascending: _sortAscending(sortMode),
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
