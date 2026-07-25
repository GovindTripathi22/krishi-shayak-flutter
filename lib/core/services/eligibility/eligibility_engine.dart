import '../../../domain/entities/eligibility_input_params.dart';
import '../../../domain/entities/eligibility_result_entity.dart';
import '../../../domain/entities/government_scheme_entity.dart';

/// Pure Modular AI Rule Evaluator Engine
class EligibilityEngine {
  static EligibilityResultEntity evaluateScheme({
    required GovernmentSchemeEntity scheme,
    required EligibilityInputParams input,
  }) {
    int totalCriteria = 6;
    int metCriteria = 0;

    final List<String> whyEligible = [];
    final List<String> whyIneligible = [];
    final List<String> missingDocuments = [];

    // 1. State / Location Match
    final bool matchState = scheme.applicableStates.any(
      (st) => st.toLowerCase() == 'all india' || st.toLowerCase() == input.state.toLowerCase(),
    );
    if (matchState) {
      metCriteria++;
      whyEligible.add('Applicable in your state (${input.state}).');
    } else {
      whyIneligible.add('Scheme is currently available in selected states: ${scheme.applicableStates.join(", ")}.');
    }

    // 2. Crop Match
    final bool matchCrop = scheme.applicableCrops.any(
      (c) => c.toLowerCase() == 'all crops' || c.toLowerCase().contains(input.primaryCrop.toLowerCase()),
    );
    if (matchCrop) {
      metCriteria++;
      whyEligible.add('Covers your primary crop (${input.primaryCrop}).');
    } else {
      whyIneligible.add('Targeted for crops: ${scheme.applicableCrops.join(", ")}.');
    }

    // 3. Category Match
    final bool matchCategory = scheme.farmerCategory.toLowerCase().contains('all') ||
        scheme.farmerCategory.toLowerCase().contains(input.farmerCategory.toLowerCase());
    if (matchCategory) {
      metCriteria++;
      whyEligible.add('Your farmer category (${input.farmerCategory}) qualifies.');
    } else {
      whyIneligible.add('Required category: ${scheme.farmerCategory}.');
    }

    // 4. Banking & Aadhaar Requirement
    if (input.hasAadhaarLinkedBank) {
      metCriteria++;
      whyEligible.add('Aadhaar-linked bank account is verified for Direct Benefit Transfer.');
    } else {
      missingDocuments.add('Aadhaar linked bank account passbook copy');
      whyIneligible.add('Aadhaar-seeded bank account is mandatory for receiving subsidy.');
    }

    // 5. Gender Restrictions
    if (scheme.genderRestrictions.toLowerCase() == 'none' ||
        scheme.genderRestrictions.toLowerCase() == input.gender.toLowerCase()) {
      metCriteria++;
    } else {
      whyIneligible.add('Scheme is restricted to ${scheme.genderRestrictions} farmers.');
    }

    // 6. Documents Availability
    missingDocuments.addAll(scheme.requiredDocuments.take(2));
    metCriteria++; // Base document score

    // Calculate Match Percentage & Category Tag
    final double rawPercentage = (metCriteria / totalCriteria) * 100.0;
    final double matchPercentage = double.parse(rawPercentage.toStringAsFixed(1));

    RecommendationCategory categoryTag;
    if (matchPercentage >= 85.0) {
      categoryTag = RecommendationCategory.highlyRecommended;
    } else if (matchPercentage >= 65.0) {
      categoryTag = RecommendationCategory.recommended;
    } else if (matchPercentage >= 40.0) {
      categoryTag = RecommendationCategory.partiallyEligible;
    } else {
      categoryTag = RecommendationCategory.notEligible;
    }

    // Generate Actionable Advice
    String actionableAdvice = 'You meet key criteria! Gather required documents and submit before ${scheme.deadline}.';
    if (!input.hasAadhaarLinkedBank) {
      actionableAdvice = 'Link your Aadhaar card with your active bank account at your nearest bank branch to qualify.';
    } else if (matchPercentage < 65.0) {
      actionableAdvice = 'Updating your land holding certificates and crop insurance details will increase your match score.';
    }

    return EligibilityResultEntity(
      scheme: scheme,
      matchPercentage: matchPercentage,
      categoryTag: categoryTag,
      whyEligible: whyEligible,
      whyIneligible: whyIneligible,
      missingDocuments: missingDocuments,
      actionableAdvice: actionableAdvice,
    );
  }

  static List<EligibilityResultEntity> evaluateAll({
    required List<GovernmentSchemeEntity> schemes,
    required EligibilityInputParams input,
  }) {
    final results = schemes.map((scheme) => evaluateScheme(scheme: scheme, input: input)).toList();

    // Sort by Match Percentage descending
    results.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
    return results;
  }
}
