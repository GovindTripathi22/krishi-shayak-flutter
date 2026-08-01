import '../../core/services/backend/api_client.dart';
import '../../domain/entities/farmer_profile_entity.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../models/government_scheme_model.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final ApiClient _apiClient;
  RecommendationRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  double _number(String value) => double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  Map<String, dynamic> _profile(FarmerProfileEntity profile) => {
    'state': profile.state, 'district': profile.district, 'village': profile.village,
    'cropType': [profile.primaryCrop, profile.secondaryCrop].where((crop) => crop.trim().isNotEmpty).toList(),
    'landSize': _number(profile.landSize), 'annualIncome': _number(profile.annualIncome), 'category': profile.farmerCategory,
    'gender': profile.gender, 'age': profile.age, 'farmerType': profile.landOwnership == 'Owned' ? 'Owner' : profile.landOwnership,
    'irrigationType': profile.irrigationType.replaceFirst(' Irrigation', ''),
  };
  List<RecommendationEntity> _read(Map<String, dynamic> response) => (response['data'] as List<dynamic>? ?? []).map((item) {
    final recommendation = Map<String, dynamic>.from(item as Map);
    return RecommendationEntity(
      scheme: GovernmentSchemeModel.fromJson(Map<String, dynamic>.from(recommendation['scheme'] as Map)),
      matchPercentage: (recommendation['matchPercentage'] as num?)?.toDouble() ?? 0,
      eligibilityStatus: recommendation['eligibilityStatus']?.toString() ?? '',
      whyRecommended: (recommendation['whyRecommended'] as List<dynamic>? ?? []).map((reason) => reason.toString()).toList(),
      missingDocuments: (recommendation['missingDocuments'] as List<dynamic>? ?? []).map((document) => document.toString()).toList(),
    );
  }).toList();
  @override
  Future<List<RecommendationEntity>> getTopRecommendations(FarmerProfileEntity profile) async {
    final current = await _apiClient.get('/recommendations/top') as Map<String, dynamic>;
    final existing = _read(current);
    if (existing.isNotEmpty) return existing;
    final refreshed = await _apiClient.post('/recommendations/refresh', body: {'profile': _profile(profile)}) as Map<String, dynamic>;
    return _read(refreshed);
  }
}
