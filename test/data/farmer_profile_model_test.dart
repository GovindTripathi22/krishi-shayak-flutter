import 'package:agrisathi_ai/data/models/farmer_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FarmerProfileModel Tests', () {
    test('FarmerProfileModel correctly serializes to and from JSON', () {
      final now = DateTime.now();
      final model = FarmerProfileModel(
        userId: 'usr_999',
        authProvider: 'phone',
        fullName: 'Suraj Farmer',
        age: 38,
        gender: 'Male',
        phoneNumber: '9876543210',
        preferredLanguage: 'hi',
        state: 'Maharashtra',
        district: 'Nashik',
        village: 'Sinnar',
        pincode: '422103',
        primaryCrop: 'Grapes',
        secondaryCrop: 'Onion',
        landSize: '4 Acres',
        landOwnership: 'Owned',
        annualIncome: '₹2,00,000',
        farmerCategory: 'Small Farmer',
        irrigationType: 'Drip',
        farmingExperience: '12 Years',
        isProfileComplete: true,
        createdAt: now,
        updatedAt: now,
      );

      final json = model.toJson();
      expect(json['userId'], equals('usr_999'));
      expect(json['fullName'], equals('Suraj Farmer'));
      expect(json['primaryCrop'], equals('Grapes'));

      final fromJson = FarmerProfileModel.fromJson(json);
      expect(fromJson.userId, equals(model.userId));
      expect(fromJson.fullName, equals(model.fullName));
      expect(fromJson.isProfileComplete, isTrue);
      expect(fromJson.completionPercentage, greaterThan(90.0));
    });
  });
}
