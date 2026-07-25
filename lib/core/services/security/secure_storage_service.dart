import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../logger/app_logger.dart';

/// Secure Storage Service wrapping FlutterSecureStorage for sensitive tokens & credentials
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _keyAuthToken = 'sec_auth_token';
  static const String _keyRefreshToken = 'sec_refresh_token';
  static const String _keyUserId = 'sec_user_id';
  static const String _keyAuthProvider = 'sec_auth_provider';

  static Future<void> saveAuthTokens({
    required String token,
    String? refreshToken,
    required String userId,
    required String authProvider,
  }) async {
    try {
      await _storage.write(key: _keyAuthToken, value: token);
      if (refreshToken != null) {
        await _storage.write(key: _keyRefreshToken, value: refreshToken);
      }
      await _storage.write(key: _keyUserId, value: userId);
      await _storage.write(key: _keyAuthProvider, value: authProvider);
      AppLogger.info('SecureStorageService: Tokens securely stored for user $userId');
    } catch (e, stack) {
      AppLogger.error('SecureStorageService Error saving tokens', e, stack);
    }
  }

  static Future<String?> getAuthToken() async {
    try {
      return await _storage.read(key: _keyAuthToken);
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _keyUserId);
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getAuthProvider() async {
    try {
      return await _storage.read(key: _keyAuthProvider);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      AppLogger.info('SecureStorageService: Cleared all stored secure tokens');
    } catch (e, stack) {
      AppLogger.error('SecureStorageService Error clearing storage', e, stack);
    }
  }
}
