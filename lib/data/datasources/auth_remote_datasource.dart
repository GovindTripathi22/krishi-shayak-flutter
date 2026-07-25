import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<bool> sendOtp(String phoneNumber);
  Future<UserModel> verifyOtp(String phoneNumber, String otp);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<bool> sendOtp(String phoneNumber) async {
    return true;
  }

  @override
  Future<UserModel> verifyOtp(String phoneNumber, String otp) async {
    return UserModel(
      id: 'usr_101',
      phoneNumber: phoneNumber,
      name: 'Kisan Mitra',
      preferredLanguage: 'hi',
      isLoggedIn: true,
    );
  }
}
