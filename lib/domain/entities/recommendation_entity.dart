import 'government_scheme_entity.dart';

class RecommendationEntity {
  final GovernmentSchemeEntity scheme;
  final double matchPercentage;
  final String eligibilityStatus;
  final List<String> whyRecommended;
  final List<String> missingDocuments;
  const RecommendationEntity({required this.scheme, required this.matchPercentage, required this.eligibilityStatus, required this.whyRecommended, required this.missingDocuments});
}
