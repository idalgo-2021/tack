import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/note.dart';
import '../../../data/repositories/note_repository.dart';

part 'search_provider.g.dart';

class SearchFilters {
  final String query;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final bool? hasImages;
  final bool? hasAudio;
  final bool? hasFiles;

  const SearchFilters({
    this.query = '',
    this.dateFrom,
    this.dateTo,
    this.hasImages,
    this.hasAudio,
    this.hasFiles,
  });

  SearchFilters copyWith({
    String? query,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool? hasImages,
    bool? hasAudio,
    bool? hasFiles,
    bool clearDateFrom = false,
    bool clearDateTo = false,
  }) {
    return SearchFilters(
      query: query ?? this.query,
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
      hasImages: hasImages ?? this.hasImages,
      hasAudio: hasAudio ?? this.hasAudio,
      hasFiles: hasFiles ?? this.hasFiles,
    );
  }
}

@riverpod
class SearchResults extends _$SearchResults {
  @override
  Future<List<Note>> build(SearchFilters filters) async {
    final query = filters.query;
    final repo = NoteRepository();

    if (query.isEmpty && filters.dateFrom == null && filters.dateTo == null &&
        filters.hasImages == null && filters.hasAudio == null && filters.hasFiles == null) {
      return [];
    }

    String? searchParam;
    String? tagParam;

    if (query.startsWith('#')) {
      tagParam = query.substring(1).trim();
      if (tagParam.isEmpty) tagParam = null;
    } else if (query.isNotEmpty) {
      searchParam = query;
    }

    return repo.getAll(
      searchQuery: searchParam,
      tagFilter: tagParam,
      dateFrom: filters.dateFrom,
      dateTo: filters.dateTo,
      hasImages: filters.hasImages,
      hasAudio: filters.hasAudio,
      hasFiles: filters.hasFiles,
    );
  }
}

@riverpod
class SearchFiltersNotifier extends _$SearchFiltersNotifier {
  @override
  SearchFilters build() => const SearchFilters();

  void setQuery(String q) => state = state.copyWith(query: q);
  void setDateFrom(DateTime? d) => state = state.copyWith(dateFrom: d);
  void setDateTo(DateTime? d) => state = state.copyWith(dateTo: d);
  void toggleHasImages() => state = state.copyWith(hasImages: state.hasImages == true ? null : true);
  void toggleHasAudio() => state = state.copyWith(hasAudio: state.hasAudio == true ? null : true);
  void toggleHasFiles() => state = state.copyWith(hasFiles: state.hasFiles == true ? null : true);
  void clearDates() => state = state.copyWith(clearDateFrom: true, clearDateTo: true);
  void clearAll() => state = const SearchFilters();
}
