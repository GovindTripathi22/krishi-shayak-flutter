import '../entities/scheme_entity.dart';

abstract class SchemeRepository {
  Future<List<SchemeEntity>> getSchemes();
  Future<List<SchemeEntity>> getBookmarkedSchemes();
  Future<void> toggleBookmark(String schemeId);
}
