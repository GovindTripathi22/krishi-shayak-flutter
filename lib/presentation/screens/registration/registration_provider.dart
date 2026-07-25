import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/farmer_profile_entity.dart';

class RegistrationDraftState {
  final int currentStep;
  final String fullName;
  final int age;
  final String gender;
  final String phoneNumber;
  final String preferredLanguage;

  final String state;
  final String district;
  final String village;
  final String pincode;

  final String primaryCrop;
  final String secondaryCrop;
  final String landSize;
  final String landOwnership;
  final String annualIncome;
  final String farmerCategory;
  final String irrigationType;
  final String farmingExperience;

  final bool locationPermission;
  final bool notificationPermission;
  final bool micPermission;
  final bool storagePermission;
  final bool cameraPermission;

  const RegistrationDraftState({
    this.currentStep = 0,
    this.fullName = '',
    this.age = 35,
    this.gender = 'Male',
    this.phoneNumber = '',
    this.preferredLanguage = 'hi',
    this.state = 'Maharashtra',
    this.district = 'Nashik',
    this.village = 'Pimplegaon',
    this.pincode = '422209',
    this.primaryCrop = 'Wheat / Wheat',
    this.secondaryCrop = 'Onion',
    this.landSize = '2.5 Acres',
    this.landOwnership = 'Owned',
    this.annualIncome = '₹1,50,000 - ₹3,00,000',
    this.farmerCategory = 'Small Farmer',
    this.irrigationType = 'Drip Irrigation',
    this.farmingExperience = '10+ Years',
    this.locationPermission = false,
    this.notificationPermission = false,
    this.micPermission = false,
    this.storagePermission = false,
    this.cameraPermission = false,
  });

  RegistrationDraftState copyWith({
    int? currentStep,
    String? fullName,
    int? age,
    String? gender,
    String? phoneNumber,
    String? preferredLanguage,
    String? state,
    String? district,
    String? village,
    String? pincode,
    String? primaryCrop,
    String? secondaryCrop,
    String? landSize,
    String? landOwnership,
    String? annualIncome,
    String? farmerCategory,
    String? irrigationType,
    String? farmingExperience,
    bool? locationPermission,
    bool? notificationPermission,
    bool? micPermission,
    bool? storagePermission,
    bool? cameraPermission,
  }) {
    return RegistrationDraftState(
      currentStep: currentStep ?? this.currentStep,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      state: state ?? this.state,
      district: district ?? this.district,
      village: village ?? this.village,
      pincode: pincode ?? this.pincode,
      primaryCrop: primaryCrop ?? this.primaryCrop,
      secondaryCrop: secondaryCrop ?? this.secondaryCrop,
      landSize: landSize ?? this.landSize,
      landOwnership: landOwnership ?? this.landOwnership,
      annualIncome: annualIncome ?? this.annualIncome,
      farmerCategory: farmerCategory ?? this.farmerCategory,
      irrigationType: irrigationType ?? this.irrigationType,
      farmingExperience: farmingExperience ?? this.farmingExperience,
      locationPermission: locationPermission ?? this.locationPermission,
      notificationPermission: notificationPermission ?? this.notificationPermission,
      micPermission: micPermission ?? this.micPermission,
      storagePermission: storagePermission ?? this.storagePermission,
      cameraPermission: cameraPermission ?? this.cameraPermission,
    );
  }

  FarmerProfileEntity toEntity(String userId, String provider) {
    return FarmerProfileEntity(
      userId: userId,
      authProvider: provider,
      fullName: fullName,
      age: age,
      gender: gender,
      phoneNumber: phoneNumber,
      preferredLanguage: preferredLanguage,
      state: state,
      district: district,
      village: village,
      pincode: pincode,
      primaryCrop: primaryCrop,
      secondaryCrop: secondaryCrop,
      landSize: landSize,
      landOwnership: landOwnership,
      annualIncome: annualIncome,
      farmerCategory: farmerCategory,
      irrigationType: irrigationType,
      farmingExperience: farmingExperience,
      isProfileComplete: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

final registrationDraftProvider =
    StateNotifierProvider<RegistrationDraftNotifier, RegistrationDraftState>((ref) {
  return RegistrationDraftNotifier();
});

class RegistrationDraftNotifier extends StateNotifier<RegistrationDraftState> {
  RegistrationDraftNotifier() : super(const RegistrationDraftState());

  void setStep(int step) => state = state.copyWith(currentStep: step);

  void updatePersonal({
    String? fullName,
    int? age,
    String? gender,
    String? phoneNumber,
    String? preferredLanguage,
  }) {
    state = state.copyWith(
      fullName: fullName,
      age: age,
      gender: gender,
      phoneNumber: phoneNumber,
      preferredLanguage: preferredLanguage,
    );
  }

  void updateLocation({
    String? stateName,
    String? district,
    String? village,
    String? pincode,
  }) {
    state = state.copyWith(
      state: stateName,
      district: district,
      village: village,
      pincode: pincode,
    );
  }

  void updateFarming({
    String? primaryCrop,
    String? secondaryCrop,
    String? landSize,
    String? landOwnership,
    String? annualIncome,
    String? farmerCategory,
    String? irrigationType,
    String? farmingExperience,
  }) {
    state = state.copyWith(
      primaryCrop: primaryCrop,
      secondaryCrop: secondaryCrop,
      landSize: landSize,
      landOwnership: landOwnership,
      annualIncome: annualIncome,
      farmerCategory: farmerCategory,
      irrigationType: irrigationType,
      farmingExperience: farmingExperience,
    );
  }

  void togglePermission(String type, bool value) {
    switch (type) {
      case 'location':
        state = state.copyWith(locationPermission: value);
        break;
      case 'notification':
        state = state.copyWith(notificationPermission: value);
        break;
      case 'mic':
        state = state.copyWith(micPermission: value);
        break;
      case 'storage':
        state = state.copyWith(storagePermission: value);
        break;
      case 'camera':
        state = state.copyWith(cameraPermission: value);
        break;
    }
  }
}
