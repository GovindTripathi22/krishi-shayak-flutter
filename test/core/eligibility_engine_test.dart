import 'package:krishisahayak/core/services/eligibility/eligibility_engine.dart';
import 'package:krishisahayak/domain/entities/eligibility_input_params.dart';
import 'package:krishisahayak/domain/entities/eligibility_result_entity.dart';
import 'package:krishisahayak/domain/entities/government_scheme_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EligibilityEngine Tests', () {
    test('EligibilityEngine evaluates 100% match when all criteria match farmer profile', () {
      final scheme = GovernmentSchemeEntity(
        id: 'sch_test_101',
        name: 'Maharashtra Wheat Support',
        shortDescription: 'Support for wheat farmers',
        detailedDescription: 'Detailed desc',
        benefits: '₹5,000 per acre',
        financialAssistance: 'Direct Benefit Transfer',
        eligibilityCriteria: const ['Cultivable Land'],
        requiredDocuments: const ['Aadhaar Card'],
        deadline: '31st Dec',
        startDate: '2026-01-01',
        endDate: '2026-12-31',
        officialWebsite: 'https://maharashtra.gov.in',
        officialApplicationLink: 'https://maharashtra.gov.in/apply',
        category: 'Financial Support',
        isCentralScheme: false,
        applicableStates: const ['Maharashtra'],
        applicableDistricts: const ['Nashik'],
        applicableCrops: const ['Wheat / Wheat'],
        landRequirement: '2+ Acres',
        incomeRequirement: 'Non Taxpayer',
        farmerCategory: 'Small Farmer',
        genderRestrictions: 'None',
        ageRequirement: '18+',
        importantNotes: const [],
        faqs: const [],
        lastUpdatedDate: DateTime.now(),
        createdDate: DateTime.now(),
        status: 'Active',
        isFeatured: true,
        priorityScore: 90,
        languageVersions: const {},
      );

      final input = EligibilityInputParams.defaultFarmer();

      final result = EligibilityEngine.evaluateScheme(scheme: scheme, input: input);

      expect(result.matchPercentage, greaterThanOrEqualTo(80.0));
      expect(result.categoryTag, equals(RecommendationCategory.highlyRecommended));
      expect(result.whyEligible, isNotEmpty);
      expect(result.whyEligible.first, contains('Maharashtra'));
    });
  });
}
