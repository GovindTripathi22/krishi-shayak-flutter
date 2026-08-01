import '../../core/services/backend/api_client.dart';
import '../../domain/entities/government_scheme_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../models/government_scheme_model.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final ApiClient _apiClient;
  BookmarkRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<GovernmentSchemeEntity>> getBookmarkedSchemes() async {
    final response = await _apiClient.get('/bookmarks') as Map<String, dynamic>;
    return (response['data'] as List<dynamic>? ?? []).map((item) => GovernmentSchemeModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }
  @override
  Future<bool> isBookmarked(String schemeId) async => (await getBookmarkedSchemes()).any((scheme) => scheme.id == schemeId);
  @override
  Future<void> addBookmark(String schemeId) async { await _apiClient.post('/bookmarks', body: {'schemeId': schemeId}); }
  @override
  Future<void> removeBookmark(String schemeId) async { await _apiClient.delete('/bookmarks/$schemeId'); }
  @override
  Future<void> toggleBookmark(String schemeId) async { if (await isBookmarked(schemeId)) { await removeBookmark(schemeId); } else { await addBookmark(schemeId); } }
  @override
  Future<void> syncBookmarks() async { await getBookmarkedSchemes(); }
}
