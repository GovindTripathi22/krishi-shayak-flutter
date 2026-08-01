import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../domain/entities/government_scheme_entity.dart';
import '../../domain/entities/scheme_filter_params.dart';
import '../../domain/entities/scheme_sort_option.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../domain/repositories/government_scheme_repository.dart';

final schemeFilterProvider = StateProvider<SchemeFilterParams>((ref) => const SchemeFilterParams());
final schemeSortProvider = StateProvider<SchemeSortOption>((ref) => SchemeSortOption.newest);
final searchQueryProvider = StateProvider<String>((ref) => '');

// Bookmarks Provider
final bookmarkNotifierProvider = StateNotifierProvider<BookmarkNotifier, List<String>>((ref) {
  return BookmarkNotifier(repository: sl<BookmarkRepository>());
});

class BookmarkNotifier extends StateNotifier<List<String>> {
  final BookmarkRepository repository;

  BookmarkNotifier({required this.repository}) : super([]) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    final schemes = await repository.getBookmarkedSchemes();
    state = schemes.map((s) => s.id).toList();
  }

  Future<void> toggleBookmark(String schemeId) async {
    await repository.toggleBookmark(schemeId);
    await loadBookmarks();
  }

  bool isBookmarked(String schemeId) => state.contains(schemeId);
}

// Schemes List Notifier
class SchemesState {
  final List<GovernmentSchemeEntity> schemes;
  final bool isLoading;
  final String? errorMessage;
  final int page;
  final bool hasMore;

  const SchemesState({
    this.schemes = const [],
    this.isLoading = false,
    this.errorMessage,
    this.page = 1,
    this.hasMore = true,
  });

  SchemesState copyWith({
    List<GovernmentSchemeEntity>? schemes,
    bool? isLoading,
    String? errorMessage,
    int? page,
    bool? hasMore,
  }) {
    return SchemesState(
      schemes: schemes ?? this.schemes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

final schemesListNotifierProvider =
    StateNotifierProvider<SchemesListNotifier, SchemesState>((ref) {
  final repo = sl<GovernmentSchemeRepository>();
  final filter = ref.watch(schemeFilterProvider);
  final sort = ref.watch(schemeSortProvider);
  final query = ref.watch(searchQueryProvider);

  return SchemesListNotifier(
    repository: repo,
    filter: filter,
    sort: sort,
    query: query,
  );
});

class SchemesListNotifier extends StateNotifier<SchemesState> {
  final GovernmentSchemeRepository repository;
  final SchemeFilterParams filter;
  final SchemeSortOption sort;
  final String query;

  SchemesListNotifier({
    required this.repository,
    required this.filter,
    required this.sort,
    required this.query,
  }) : super(const SchemesState()) {
    fetchSchemes(refresh: true);
  }

  Future<void> fetchSchemes({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(isLoading: true, errorMessage: null, page: 1);
    }

    try {
      List<GovernmentSchemeEntity> results = [];
      if (query.trim().isNotEmpty) {
        results = await repository.searchSchemes(query, page: refresh ? 1 : state.page, pageSize: 20, filter: filter, sort: sort);
      } else {
        results = await repository.getSchemes(
          page: refresh ? 1 : state.page,
          pageSize: 20,
          filter: filter,
          sort: sort,
        );
      }

      state = state.copyWith(
        schemes: refresh ? results : [...state.schemes, ...results],
        isLoading: false,
        hasMore: results.length >= 20,
        page: refresh ? 1 : state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load government schemes. Please swipe down to retry.',
      );
    }
  }
}
