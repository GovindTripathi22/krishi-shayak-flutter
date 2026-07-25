import '../entities/farmer_profile_entity.dart';

abstract class UserRepository {
  Future<FarmerProfileEntity?> getProfile(String userId);
  Future<void> saveProfile(FarmerProfileEntity profile);
  Future<void> updateProfile(FarmerProfileEntity profile);
  Future<void> deleteProfile(String userId);
}
