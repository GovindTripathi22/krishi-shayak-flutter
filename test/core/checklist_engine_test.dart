import 'package:krishisahayak/core/services/checklist/checklist_engine.dart';
import 'package:krishisahayak/domain/entities/government_scheme_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChecklistEngine Tests', () {
    test('generateChecklist creates checklist items with AI explanations from scheme entity', () {
      final scheme = GovernmentSchemeEntity(
        id: 'sch_pmkisan_test',
        name: 'PM-KISAN Subsidies',
        shortDescription: 'Desc',
        detailedDescription: 'Detailed',
        benefits: '₹6,000',
        financialAssistance: 'DBT',
        eligibilityCriteria: const ['Landholder'],
        requiredDocuments: const ['Aadhaar Card', '7/12 Land Extract', 'Bank Passbook'],
        deadline: 'Ongoing',
        startDate: '2020-01-01',
        endDate: '2030-12-31',
        officialWebsite: 'https://pmkisan.gov.in',
        officialApplicationLink: 'https://pmkisan.gov.in/apply',
        category: 'Financial Assistance',
        isCentralScheme: true,
        applicableStates: const ['All India'],
        applicableDistricts: const ['All Districts'],
        applicableCrops: const ['All Crops'],
        landRequirement: 'Cultivable',
        incomeRequirement: 'Non Taxpayer',
        farmerCategory: 'All',
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

      final checklist = ChecklistEngine.generateChecklist(scheme);

      expect(checklist.items.length, equals(3));
      expect(checklist.items[0].documentName, equals('Aadhaar Card'));
      expect(checklist.items[0].purposeExplanation, contains('Direct Benefit Transfer'));
      expect(checklist.completionPercentage, equals(0.0));
    });
  });
}
