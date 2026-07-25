import '../../core/logger/app_logger.dart';
import '../../domain/entities/government_scheme_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../domain/repositories/government_scheme_repository.dart';
import '../datasources/scheme_local_datasource.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final SchemeLocalDataSource localDataSource;
  final GovernmentSchemeRepository schemeRepository;

  BookmarkRepositoryImpl({
    required this.localDataSource,
    required this.schemeRepository,
  });

  @override
  Future<List<GovernmentSchemeEntity>> getBookmarkedSchemes() async {
    final bookmarkedIds = await localDataSource.getBookmarkedSchemeIds();
    final allSchemes = await schemeRepository.getSchemes(pageSize: 100);

    return allSchemes.where((s) => bookmarkedIds.contains(s.id)).map((s) => s.copyWith(isBookmarked: true)).toList();
  }

  @override
  Future<bool> isBookmarked(String schemeId) async {
    final ids = await localDataSource.getBookmarkedSchemeIds();
    return ids.contains(schemeId);
  }

  @override
  Future<void> addBookmark(String schemeId) async {
    final ids = await localDataSource.getBookmarkedSchemeIds();
    if (!ids.contains(schemeId)) {
      ids.add(schemeId);
      await localDataSource.saveBookmarkedSchemeIds(ids);
      AppLogger.info('BookmarkRepositoryImpl: Added bookmark $schemeId');
    }
  }

  @override
  Future<void> removeBookmark(String schemeId) async {
    final ids = await localDataSource.getBookmarkedSchemeIds();
    if (ids.contains(schemeId)) {
      ids.remove(schemeId);
      await localDataSource.saveBookmarkedSchemeIds(ids);
      AppLogger.info('BookmarkRepositoryImpl: Removed bookmark $schemeId');
    }
  }

  @override
  Future<void> toggleBookmark(String schemeId) async {
    final bookmarked = await isBookmarked(schemeId);
    if (bookmarked) {
      await removeBookmark(schemeId);
    } else {
      await addBookmark(schemeId);
    }
  }

  @override
  Future<void> syncBookmarks() async {
    AppLogger.info('BookmarkRepositoryImpl: Syncing bookmarks with backend');
  }
}
