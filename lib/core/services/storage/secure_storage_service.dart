import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../logger/app_logger.dart';

/// Secure Storage Service for storing ONLY JWT Tokens and Session Keys
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _keyAccessToken = 'jwt_access_token';
  static const String _keyRefreshToken = 'jwt_refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyLanguage = 'preferred_language';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    AppLogger.info('SecureStorageService: Saving JWT session tokens');
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    await _storage.write(key: _keyUserId, value: userId);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  static Future<void> saveLanguage(String langCode) async {
    await _storage.write(key: _keyLanguage, value: langCode);
  }

  static Future<String?> getLanguage() async {
    return await _storage.read(key: _keyLanguage);
  }

  static Future<void> clearSession() async {
    AppLogger.info('SecureStorageService: Clearing JWT session');
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUserId);
  }
}
