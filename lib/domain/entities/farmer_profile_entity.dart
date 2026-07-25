import 'package:equatable/equatable.dart';

class FarmerProfileEntity extends Equatable {
  final String userId;
  final String authProvider; // 'phone', 'google', 'guest'
  final String fullName;
  final int age;
  final String gender;
  final String phoneNumber;
  final String preferredLanguage;

  // Location Details
  final String state;
  final String district;
  final String village;
  final String pincode;

  // Farming Details
  final String primaryCrop;
  final String secondaryCrop;
  final String landSize;
  final String landOwnership;
  final String annualIncome;
  final String farmerCategory;
  final String irrigationType;
  final String farmingExperience;

  // System & Status
  final bool isProfileComplete;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FarmerProfileEntity({
    required this.userId,
    required this.authProvider,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.preferredLanguage,
    required this.state,
    required this.district,
    required this.village,
    required this.pincode,
    required this.primaryCrop,
    required this.secondaryCrop,
    required this.landSize,
    required this.landOwnership,
    required this.annualIncome,
    required this.farmerCategory,
    required this.irrigationType,
    required this.farmingExperience,
    required this.isProfileComplete,
    required this.createdAt,
    required this.updatedAt,
  });

  double get completionPercentage {
    int totalFields = 16;
    int filledFields = 0;

    if (fullName.isNotEmpty) filledFields++;
    if (age > 0) filledFields++;
    if (gender.isNotEmpty) filledFields++;
    if (phoneNumber.isNotEmpty) filledFields++;
    if (preferredLanguage.isNotEmpty) filledFields++;
    if (state.isNotEmpty) filledFields++;
    if (district.isNotEmpty) filledFields++;
    if (village.isNotEmpty) filledFields++;
    if (pincode.isNotEmpty) filledFields++;
    if (primaryCrop.isNotEmpty) filledFields++;
    if (secondaryCrop.isNotEmpty) filledFields++;
    if (landSize.isNotEmpty) filledFields++;
    if (landOwnership.isNotEmpty) filledFields++;
    if (annualIncome.isNotEmpty) filledFields++;
    if (farmerCategory.isNotEmpty) filledFields++;
    if (irrigationType.isNotEmpty) filledFields++;

    return (filledFields / totalFields) * 100.0;
  }

  @override
  List<Object?> get props => [
        userId,
        authProvider,
        fullName,
        age,
        gender,
        phoneNumber,
        preferredLanguage,
        state,
        district,
        village,
        pincode,
        primaryCrop,
        secondaryCrop,
        landSize,
        landOwnership,
        annualIncome,
        farmerCategory,
        irrigationType,
        farmingExperience,
        isProfileComplete,
        createdAt,
        updatedAt,
      ];
}
