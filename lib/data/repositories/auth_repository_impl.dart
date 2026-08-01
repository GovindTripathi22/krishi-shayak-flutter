import '../../core/services/backend/api_client.dart';
import '../../core/services/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  bool _isGuest = false;

  AuthRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      final res = await _apiClient.post('/auth/send-otp', body: {'phoneNumber': phoneNumber}, requireAuth: false);
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<UserEntity?> verifyOtp(String phoneNumber, String otp) async {
    try {
      final res = await _apiClient.post('/auth/verify-otp', body: {'phoneNumber': phoneNumber, 'otp': otp}, requireAuth: false);
      if (res['success'] == true && res['tokens'] != null) {
        await SecureStorageService.saveTokens(
          accessToken: res['tokens']['accessToken'],
          refreshToken: res['tokens']['refreshToken'],
          userId: res['user']['id'],
        );
        _isGuest = false;
        return UserEntity(
          id: res['user']['id'] ?? 'user_1',
          phoneNumber: phoneNumber,
          isVerified: true,
          createdAt: DateTime.now(),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      final res = await _apiClient.post(
        '/auth/google',
        body: {'email': 'farmer@gmail.com', 'fullName': 'Farmer Friend', 'googleToken': 'sample_google_token'},
        requireAuth: false,
      );
      if (res['success'] == true && res['tokens'] != null) {
        await SecureStorageService.saveTokens(
          accessToken: res['tokens']['accessToken'],
          refreshToken: res['tokens']['refreshToken'],
          userId: res['user']['id'],
        );
        _isGuest = false;
        return UserEntity(
          id: res['user']['id'] ?? 'user_google',
          phoneNumber: '+919876543210',
          email: 'farmer@gmail.com',
          isVerified: true,
          createdAt: DateTime.now(),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserEntity?> signInAsGuest() async {
    _isGuest = true;
    return UserEntity(
      id: 'guest_user',
      phoneNumber: '',
      isVerified: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<UserEntity?> restoreSession() async {
    final token = await SecureStorageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      final userId = await SecureStorageService.getUserId() ?? 'user_restored';
      return UserEntity(
        id: userId,
        phoneNumber: '+919876543210',
        isVerified: true,
        createdAt: DateTime.now(),
      );
    }
    return null;
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout', requireAuth: true);
    } catch (_) {}
    await SecureStorageService.clearSession();
    _isGuest = false;
  }

  @override
  Future<bool> deleteAccount() async {
    try {
      await _apiClient.delete('/auth/account');
      await SecureStorageService.clearSession();
      _isGuest = false;
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  bool get isGuestUser => _isGuest;
}
