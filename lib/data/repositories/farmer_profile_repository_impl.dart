import '../../core/services/backend/api_client.dart';
import '../../domain/entities/farmer_profile_entity.dart';

abstract class IFarmerProfileRepository {
  Future<FarmerProfileEntity?> getProfile();
  Future<bool> saveProfile(FarmerProfileEntity profile);
}

class FarmerProfileRepositoryImpl implements IFarmerProfileRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<FarmerProfileEntity?> getProfile() async {
    try {
      final res = await _apiClient.get('/profile', requireAuth: true);
      if (res['success'] == true && res['profile'] != null) {
        final p = res['profile'];
        return FarmerProfileEntity(
          id: p['_id'] ?? '',
          fullName: p['fullName'] ?? '',
          phoneNumber: p['phoneNumber'] ?? '',
          gender: p['gender'] ?? 'Male',
          age: p['age'] ?? 35,
          state: p['state'] ?? 'Maharashtra',
          district: p['district'] ?? 'Nashik',
          landSizeInAcres: (p['landSize'] as num?)?.toDouble() ?? 2.0,
          primaryCrops: List<String>.from(p['cropType'] ?? ['Cotton']),
          farmerCategory: p['category'] ?? 'Small Farmer',
          annualIncome: (p['annualIncome'] as num?)?.toDouble() ?? 120000.0,
          preferredLanguage: p['preferredLanguage'] ?? 'en',
          createdDate: DateTime.now(),
          lastUpdatedDate: DateTime.now(),
        );
      }
    } catch (_) {}

    // Default Fallback Entity
    return const FarmerProfileEntity(
      id: 'profile_101',
      fullName: 'Ramesh Patil',
      phoneNumber: '+919876543210',
      gender: 'Male',
      age: 38,
      state: 'Maharashtra',
      district: 'Nashik',
      landSizeInAcres: 3.0,
      primaryCrops: ['Cotton', 'Wheat'],
      farmerCategory: 'Small Farmer',
      annualIncome: 120000.0,
      preferredLanguage: 'en',
    );
  }

  @override
  Future<bool> saveProfile(FarmerProfileEntity profile) async {
    try {
      final res = await _apiClient.put(
        '/profile',
        body: {
          'fullName': profile.fullName,
          'gender': profile.gender,
          'age': profile.age,
          'state': profile.state,
          'district': profile.district,
          'landSize': profile.landSizeInAcres,
          'cropType': profile.primaryCrops,
          'category': profile.farmerCategory,
          'annualIncome': profile.annualIncome,
          'preferredLanguage': profile.preferredLanguage,
        },
        requireAuth: true,
      );
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
