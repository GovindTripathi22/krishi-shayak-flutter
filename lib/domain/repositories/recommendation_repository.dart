import '../entities/farmer_profile_entity.dart';
import '../entities/recommendation_entity.dart';

abstract class RecommendationRepository {
  Future<List<RecommendationEntity>> getTopRecommendations(FarmerProfileEntity profile);
}
