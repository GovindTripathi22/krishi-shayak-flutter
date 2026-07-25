import '../../logger/app_logger.dart';

abstract class IAuthService {
  Future<bool> sendOtp(String phoneNumber);
  Future<bool> verifyOtp(String otp);
  Future<void> signOut();
  bool get isAuthenticated;
  String? get currentUserId;
}

class FirebaseAuthService implements IAuthService {
  @override
  Future<bool> sendOtp(String phoneNumber) async {
    AppLogger.info('FirebaseAuthService: Sending OTP to $phoneNumber');
    return true;
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    AppLogger.info('FirebaseAuthService: Verifying OTP $otp');
    return true;
  }

  @override
  Future<void> signOut() async {
    AppLogger.info('FirebaseAuthService: User signed out');
  }

  @override
  bool get isAuthenticated => false;

  @override
  String? get currentUserId => null;
}
