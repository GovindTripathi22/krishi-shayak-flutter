import 'dart:convert';
import '../../core/logger/app_logger.dart';
import '../../core/services/storage/preferences_service.dart';
import '../models/government_scheme_model.dart';

abstract class SchemeLocalDataSource {
  Future<void> cacheSchemes(List<GovernmentSchemeModel> schemes);
  Future<List<GovernmentSchemeModel>> getCachedSchemes();
  Future<List<String>> getBookmarkedSchemeIds();
  Future<void> saveBookmarkedSchemeIds(List<String> ids);
}

class SchemeLocalDataSourceImpl implements SchemeLocalDataSource {
  static const String _keyCachedSchemes = 'cache_gov_schemes_v1';
  static const String _keyBookmarks = 'cache_bookmarked_scheme_ids_v1';

  @override
  Future<void> cacheSchemes(List<GovernmentSchemeModel> schemes) async {
    try {
      final jsonList = schemes.map((s) => s.toJson()).toList();
      await PreferencesService.setString(_keyCachedSchemes, jsonEncode(jsonList));
      AppLogger.info('SchemeLocalDataSource: Cached ${schemes.length} schemes locally');
    } catch (e, stack) {
      AppLogger.error('SchemeLocalDataSource: Error caching schemes', e, stack);
    }
  }

  @override
  Future<List<GovernmentSchemeModel>> getCachedSchemes() async {
    try {
      final rawStr = PreferencesService.getString(_keyCachedSchemes);
      if (rawStr != null && rawStr.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(rawStr);
        return jsonList.map((j) => GovernmentSchemeModel.fromJson(j as Map<String, dynamic>)).toList();
      }
    } catch (e, stack) {
      AppLogger.error('SchemeLocalDataSource: Error reading cached schemes', e, stack);
    }
    return [];
  }

  @override
  Future<List<String>> getBookmarkedSchemeIds() async {
    try {
      final rawStr = PreferencesService.getString(_keyBookmarks);
      if (rawStr != null && rawStr.isNotEmpty) {
        final List<dynamic> list = jsonDecode(rawStr);
        return list.map((e) => e.toString()).toList();
      }
    } catch (e) {
      // Return empty list on parse error
    }
    return [];
  }

  @override
  Future<void> saveBookmarkedSchemeIds(List<String> ids) async {
    try {
      await PreferencesService.setString(_keyBookmarks, jsonEncode(ids));
      AppLogger.info('SchemeLocalDataSource: Saved ${ids.length} bookmarks');
    } catch (e, stack) {
      AppLogger.error('SchemeLocalDataSource: Error saving bookmarks', e, stack);
    }
  }
}
