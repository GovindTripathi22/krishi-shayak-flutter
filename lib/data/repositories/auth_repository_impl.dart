import '../../core/logger/app_logger.dart';
import '../../core/services/security/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  bool _isGuest = false;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  bool get isGuestUser => _isGuest;

  @override
  Future<bool> sendOtp(String phoneNumber) async {
    AppLogger.info('AuthRepositoryImpl: Sending OTP to $phoneNumber');
    return await remoteDataSource.sendOtp(phoneNumber);
  }

  @override
  Future<UserEntity?> verifyOtp(String phoneNumber, String otp) async {
    AppLogger.info('AuthRepositoryImpl: Verifying OTP $otp for $phoneNumber');
    final userModel = await remoteDataSource.verifyOtp(phoneNumber, otp);
    _isGuest = false;

    // Secure Token Storage
    await SecureStorageService.saveAuthTokens(
      token: 'jwt_sec_token_${userModel.id}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userModel.id,
      authProvider: 'phone',
    );

    return userModel;
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    AppLogger.info('AuthRepositoryImpl: Initiating Google Sign-In');
    _isGuest = false;
    
    final user = UserEntity(
      id: 'google_usr_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: '',
      name: 'Kisan Google User',
      preferredLanguage: 'hi',
      isLoggedIn: true,
    );

    await SecureStorageService.saveAuthTokens(
      token: 'jwt_google_token_${user.id}',
      userId: user.id,
      authProvider: 'google',
    );

    return user;
  }

  @override
  Future<UserEntity?> signInAsGuest() async {
    AppLogger.info('AuthRepositoryImpl: Logging in as Guest');
    _isGuest = true;
    
    final guestUser = UserEntity(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: '',
      name: 'Guest Farmer',
      preferredLanguage: 'hi',
      isLoggedIn: true,
    );

    await SecureStorageService.saveAuthTokens(
      token: 'guest_session_token',
      userId: guestUser.id,
      authProvider: 'guest',
    );

    return guestUser;
  }

  @override
  Future<UserEntity?> restoreSession() async {
    final token = await SecureStorageService.getAuthToken();
    final userId = await SecureStorageService.getUserId();
    final provider = await SecureStorageService.getAuthProvider();

    if (token != null && userId != null) {
      AppLogger.info('AuthRepositoryImpl: Session restored for user $userId (provider: $provider)');
      _isGuest = (provider == 'guest');
      return UserEntity(
        id: userId,
        phoneNumber: provider == 'phone' ? '9876543210' : '',
        name: provider == 'guest' ? 'Guest Farmer' : 'Kisan Mitra',
        preferredLanguage: 'hi',
        isLoggedIn: true,
      );
    }
    return null;
  }

  @override
  Future<void> logout() async {
    AppLogger.info('AuthRepositoryImpl: User logged out');
    _isGuest = false;
    await SecureStorageService.clearAll();
  }

  @override
  Future<bool> deleteAccount() async {
    AppLogger.info('AuthRepositoryImpl: Account deletion requested');
    _isGuest = false;
    await SecureStorageService.clearAll();
    return true;
  }
}
