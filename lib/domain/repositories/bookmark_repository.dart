import '../entities/government_scheme_entity.dart';

abstract class BookmarkRepository {
  Future<List<GovernmentSchemeEntity>> getBookmarkedSchemes();
  Future<bool> isBookmarked(String schemeId);
  Future<void> addBookmark(String schemeId);
  Future<void> removeBookmark(String schemeId);
  Future<void> toggleBookmark(String schemeId);
  Future<void> syncBookmarks();
}
