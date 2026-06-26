import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/note.dart';
import '../../../core/providers/repository_providers.dart';

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

  static const _sentinel = _SearchSentinel();

  SearchFilters copyWith({
    String? query,
    Object? dateFrom = _sentinel,
    Object? dateTo = _sentinel,
    bool? hasImages,
    bool? hasAudio,
    bool? hasFiles,
  }) {
    return SearchFilters(
      query: query ?? this.query,
      dateFrom: identical(dateFrom, _sentinel) ? this.dateFrom : dateFrom as DateTime?,
      dateTo: identical(dateTo, _sentinel) ? this.dateTo : dateTo as DateTime?,
      hasImages: hasImages ?? this.hasImages,
      hasAudio: hasAudio ?? this.hasAudio,
      hasFiles: hasFiles ?? this.hasFiles,
    );
  }

  bool get hasActiveFilters {
    return query.isNotEmpty ||
        dateFrom != null ||
        dateTo != null ||
        hasImages == true ||
        hasAudio == true ||
        hasFiles == true;
  }
}

class _SearchSentinel {
  const _SearchSentinel();
}

@riverpod
class SearchResults extends _$SearchResults {
  @override
  Future<List<Note>> build(SearchFilters filters) async {
    final query = filters.query;
    final repo = ref.watch(noteRepositoryProvider);

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
  void clearDates() => state = state.copyWith(dateFrom: null, dateTo: null);
  void clearAll() => state = const SearchFilters();
}
