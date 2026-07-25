import 'package:equatable/equatable.dart';

class EligibilityInputParams extends Equatable {
  final String state;
  final String district;
  final String village;
  final String primaryCrop;
  final String landSize;
  final String landOwnership;
  final String annualIncome;
  final String farmerCategory;
  final String gender;
  final int age;
  final String irrigationType;
  final bool isOrganicFarming;
  final bool hasAadhaarLinkedBank;
  final bool hasCropInsurance;

  const EligibilityInputParams({
    required this.state,
    required this.district,
    required this.village,
    required this.primaryCrop,
    required this.landSize,
    required this.landOwnership,
    required this.annualIncome,
    required this.farmerCategory,
    required this.gender,
    required this.age,
    required this.irrigationType,
    required this.isOrganicFarming,
    required this.hasAadhaarLinkedBank,
    required this.hasCropInsurance,
  });

  factory EligibilityInputParams.defaultFarmer() {
    return const EligibilityInputParams(
      state: 'Maharashtra',
      district: 'Nashik',
      village: 'Pimplegaon',
      primaryCrop: 'Wheat / Wheat',
      landSize: '2.5 Acres',
      landOwnership: 'Owned',
      annualIncome: '₹1,50,000 - ₹3,00,000',
      farmerCategory: 'Small Farmer',
      gender: 'Male',
      age: 42,
      irrigationType: 'Drip Irrigation',
      isOrganicFarming: false,
      hasAadhaarLinkedBank: true,
      hasCropInsurance: true,
    );
  }

  EligibilityInputParams copyWith({
    String? state,
    String? district,
    String? village,
    String? primaryCrop,
    String? landSize,
    String? landOwnership,
    String? annualIncome,
    String? farmerCategory,
    String? gender,
    int? age,
    String? irrigationType,
    bool? isOrganicFarming,
    bool? hasAadhaarLinkedBank,
    bool? hasCropInsurance,
  }) {
    return EligibilityInputParams(
      state: state ?? this.state,
      district: district ?? this.district,
      village: village ?? this.village,
      primaryCrop: primaryCrop ?? this.primaryCrop,
      landSize: landSize ?? this.landSize,
      landOwnership: landOwnership ?? this.landOwnership,
      annualIncome: annualIncome ?? this.annualIncome,
      farmerCategory: farmerCategory ?? this.farmerCategory,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      irrigationType: irrigationType ?? this.irrigationType,
      isOrganicFarming: isOrganicFarming ?? this.isOrganicFarming,
      hasAadhaarLinkedBank: hasAadhaarLinkedBank ?? this.hasAadhaarLinkedBank,
      hasCropInsurance: hasCropInsurance ?? this.hasCropInsurance,
    );
  }

  @override
  List<Object?> get props => [
        state,
        district,
        village,
        primaryCrop,
        landSize,
        landOwnership,
        annualIncome,
        farmerCategory,
        gender,
        age,
        irrigationType,
        isOrganicFarming,
        hasAadhaarLinkedBank,
        hasCropInsurance,
      ];
}
