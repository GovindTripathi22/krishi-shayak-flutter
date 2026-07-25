import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<bool> sendOtp(String phoneNumber);
  Future<UserEntity?> verifyOtp(String phoneNumber, String otp);
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInAsGuest();
  Future<UserEntity?> restoreSession();
  Future<void> logout();
  Future<bool> deleteAccount();
  bool get isGuestUser;
}
