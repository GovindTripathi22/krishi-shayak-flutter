import 'package:agrisathi_ai/data/models/government_scheme_model.dart';
import 'package:agrisathi_ai/domain/entities/scheme_faq.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GovernmentSchemeModel Tests', () {
    test('GovernmentSchemeModel correctly parses JSON with all mandatory Phase 3 fields', () {
      final now = DateTime.now();
      final model = GovernmentSchemeModel(
        id: 'sch_test_1',
        name: 'PM-KISAN Test',
        shortDescription: 'Short desc',
        detailedDescription: 'Detailed desc',
        benefits: '₹6000',
        financialAssistance: '100% DBT',
        eligibilityCriteria: const ['Landholder'],
        requiredDocuments: const ['Aadhaar'],
        deadline: 'Ongoing',
        startDate: '2018-12-01',
        endDate: '2030-12-31',
        officialWebsite: 'https://pmkisan.gov.in',
        officialApplicationLink: 'https://pmkisan.gov.in/apply',
        category: 'Financial Assistance',
        isCentralScheme: true,
        applicableStates: const ['All India'],
        applicableDistricts: const ['All Districts'],
        applicableCrops: const ['All Crops'],
        landRequirement: 'Cultivable Land',
        incomeRequirement: 'Non Taxpayer',
        farmerCategory: 'All',
        genderRestrictions: 'None',
        ageRequirement: '18+',
        importantNotes: const ['eKYC required'],
        faqs: const [
          SchemeFaq(question: 'Q1', answer: 'A1'),
        ],
        lastUpdatedDate: now,
        createdDate: now,
        status: 'Active',
        isFeatured: true,
        priorityScore: 90,
        languageVersions: const {'en': 'PM-KISAN'},
        isBookmarked: false,
      );

      final json = model.toJson();
      expect(json['id'], equals('sch_test_1'));
      expect(json['category'], equals('Financial Assistance'));
      expect(json['isCentralScheme'], isTrue);

      final fromJson = GovernmentSchemeModel.fromJson(json);
      expect(fromJson.id, equals(model.id));
      expect(fromJson.faqs.length, equals(1));
      expect(fromJson.faqs.first.question, equals('Q1'));
    });
  });
}
