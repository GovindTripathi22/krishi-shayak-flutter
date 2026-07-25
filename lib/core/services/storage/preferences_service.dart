import 'package:shared_preferences/shared_preferences.dart';

import '../../logger/app_logger.dart';

/// Local SharedPreferences Wrapper Service
class PreferencesService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e, stack) {
      AppLogger.error('Failed to initialize SharedPreferences', e, stack);
    }
  }

  static String? getString(String key) => _prefs?.getString(key);
  static Future<bool> setString(String key, String value) async => _prefs?.setString(key, value) ?? Future.value(false);

  static bool? getBool(String key) => _prefs?.getBool(key);
  static Future<bool> setBool(String key, bool value) async => _prefs?.setBool(key, value) ?? Future.value(false);

  static int? getInt(String key) => _prefs?.getInt(key);
  static Future<bool> setInt(String key, int value) async => _prefs?.setInt(key, value) ?? Future.value(false);

  static Future<bool> remove(String key) async => _prefs?.remove(key) ?? Future.value(false);
  static Future<bool> clear() async => _prefs?.clear() ?? Future.value(false);
}
