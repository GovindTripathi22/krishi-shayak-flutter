import '../../core/services/backend/api_client.dart';
import '../../core/services/storage/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final ApiClient _apiClient = ApiClient();

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
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    try {
      final res = await _apiClient.post('/auth/verify-otp', body: {'phoneNumber': phoneNumber, 'otp': otp}, requireAuth: false);
      if (res['success'] == true && res['tokens'] != null) {
        await SecureStorageService.saveTokens(
          accessToken: res['tokens']['accessToken'],
          refreshToken: res['tokens']['refreshToken'],
          userId: res['user']['id'],
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> loginWithGoogle() async {
    try {
      final res = await _apiClient.post(
        '/auth/google',
        body: {'email': 'farmer@gmail.com', 'fullName': 'Ramesh Patil', 'googleToken': 'sample_google_token'},
        requireAuth: false,
      );
      if (res['success'] == true && res['tokens'] != null) {
        await SecureStorageService.saveTokens(
          accessToken: res['tokens']['accessToken'],
          refreshToken: res['tokens']['refreshToken'],
          userId: res['user']['id'],
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout', requireAuth: true);
    } catch (_) {}
    await SecureStorageService.clearSession();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await SecureStorageService.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
