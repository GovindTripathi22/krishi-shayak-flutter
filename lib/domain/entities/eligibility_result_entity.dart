import 'package:equatable/equatable.dart';
import 'government_scheme_entity.dart';

enum RecommendationCategory {
  highlyRecommended, // 85% - 100%
  recommended,       // 65% - 84%
  partiallyEligible, // 40% - 64%
  notEligible,       // 0% - 39%
}

extension RecommendationCategoryX on RecommendationCategory {
  String get label {
    switch (this) {
      case RecommendationCategory.highlyRecommended:
        return 'Highly Recommended';
      case RecommendationCategory.recommended:
        return 'Recommended';
      case RecommendationCategory.partiallyEligible:
        return 'Explore Later';
      case RecommendationCategory.notEligible:
        return 'Not Eligible';
    }
  }
}

class EligibilityResultEntity extends Equatable {
  final GovernmentSchemeEntity scheme;
  final double matchPercentage;
  final RecommendationCategory categoryTag;
  final List<String> whyEligible;
  final List<String> whyIneligible;
  final List<String> missingDocuments;
  final String actionableAdvice;

  const EligibilityResultEntity({
    required this.scheme,
    required this.matchPercentage,
    required this.categoryTag,
    required this.whyEligible,
    required this.whyIneligible,
    required this.missingDocuments,
    required this.actionableAdvice,
  });

  @override
  List<Object?> get props => [
        scheme,
        matchPercentage,
        categoryTag,
        whyEligible,
        whyIneligible,
        missingDocuments,
        actionableAdvice,
      ];
}
