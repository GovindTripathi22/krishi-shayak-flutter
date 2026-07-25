import '../../domain/entities/farmer_profile_entity.dart';

class FarmerProfileModel extends FarmerProfileEntity {
  const FarmerProfileModel({
    required super.userId,
    required super.authProvider,
    required super.fullName,
    required super.age,
    required super.gender,
    required super.phoneNumber,
    required super.preferredLanguage,
    required super.state,
    required super.district,
    required super.village,
    required super.pincode,
    required super.primaryCrop,
    required super.secondaryCrop,
    required super.landSize,
    required super.landOwnership,
    required super.annualIncome,
    required super.farmerCategory,
    required super.irrigationType,
    required super.farmingExperience,
    required super.isProfileComplete,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FarmerProfileModel.fromJson(Map<String, dynamic> json) {
    return FarmerProfileModel(
      userId: json['userId'] as String? ?? '',
      authProvider: json['authProvider'] as String? ?? 'phone',
      fullName: json['fullName'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      state: json['state'] as String? ?? '',
      district: json['district'] as String? ?? '',
      village: json['village'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      primaryCrop: json['primaryCrop'] as String? ?? '',
      secondaryCrop: json['secondaryCrop'] as String? ?? '',
      landSize: json['landSize'] as String? ?? '',
      landOwnership: json['landOwnership'] as String? ?? '',
      annualIncome: json['annualIncome'] as String? ?? '',
      farmerCategory: json['farmerCategory'] as String? ?? '',
      irrigationType: json['irrigationType'] as String? ?? '',
      farmingExperience: json['farmingExperience'] as String? ?? '',
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'authProvider': authProvider,
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'preferredLanguage': preferredLanguage,
      'state': state,
      'district': district,
      'village': village,
      'pincode': pincode,
      'primaryCrop': primaryCrop,
      'secondaryCrop': secondaryCrop,
      'landSize': landSize,
      'landOwnership': landOwnership,
      'annualIncome': annualIncome,
      'farmerCategory': farmerCategory,
      'irrigationType': irrigationType,
      'farmingExperience': farmingExperience,
      'isProfileComplete': isProfileComplete,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory FarmerProfileModel.fromEntity(FarmerProfileEntity entity) {
    return FarmerProfileModel(
      userId: entity.userId,
      authProvider: entity.authProvider,
      fullName: entity.fullName,
      age: entity.age,
      gender: entity.gender,
      phoneNumber: entity.phoneNumber,
      preferredLanguage: entity.preferredLanguage,
      state: entity.state,
      district: entity.district,
      village: entity.village,
      pincode: entity.pincode,
      primaryCrop: entity.primaryCrop,
      secondaryCrop: entity.secondaryCrop,
      landSize: entity.landSize,
      landOwnership: entity.landOwnership,
      annualIncome: entity.annualIncome,
      farmerCategory: entity.farmerCategory,
      irrigationType: entity.irrigationType,
      farmingExperience: entity.farmingExperience,
      isProfileComplete: entity.isProfileComplete,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
