import '../../core/services/backend/api_client.dart';
import '../../domain/entities/eligibility_history_entity.dart';
import '../../domain/entities/eligibility_input_params.dart';
import '../../domain/entities/eligibility_result_entity.dart';
import '../../domain/entities/government_scheme_entity.dart';
import '../../domain/entities/scheme_faq.dart';
import '../../domain/repositories/eligibility_repository.dart';
import '../models/government_scheme_model.dart';

class EligibilityRepositoryImpl implements EligibilityRepository {
  final ApiClient _apiClient;
  EligibilityRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Map<String, dynamic> _profile(EligibilityInputParams input) => {
    'state': input.state, 'district': input.district, 'village': input.village,
    'cropType': input.primaryCrop.split('/').map((crop) => crop.trim()).where((crop) => crop.isNotEmpty).toList(),
    'landSize': _number(input.landSize), 'annualIncome': _number(input.annualIncome),
    'category': input.farmerCategory, 'gender': input.gender, 'age': input.age,
    'farmerType': input.landOwnership == 'Owned' ? 'Owner' : input.landOwnership,
    'irrigationType': input.irrigationType.replaceFirst(' Irrigation', ''),
  };
  double _number(String raw) => double.tryParse(raw.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  GovernmentSchemeEntity _scheme(Map<String, dynamic> json) => GovernmentSchemeModel.fromJson(json);
  RecommendationCategory _category(String status) => switch (status) {
    'Eligible' => RecommendationCategory.highlyRecommended,
    'Partially Eligible' => RecommendationCategory.partiallyEligible,
    _ => RecommendationCategory.notEligible,
  };
  EligibilityResultEntity _result(Map<String, dynamic> data) {
    final suggestions = (data['suggestions'] as List<dynamic>? ?? []).map((item) => item.toString()).toList();
    return EligibilityResultEntity(
      scheme: _scheme(Map<String, dynamic>.from(data['scheme'] as Map)),
      matchPercentage: (data['matchPercentage'] as num?)?.toDouble() ?? 0,
      categoryTag: _category(data['status']?.toString() ?? ''),
      whyEligible: (data['reasons'] as List<dynamic>? ?? []).map((item) => item.toString()).toList(),
      whyIneligible: (data['missingCriteria'] as List<dynamic>? ?? []).map((item) => item.toString()).toList(),
      missingDocuments: (data['missingDocuments'] as List<dynamic>? ?? []).map((item) => item.toString()).toList(),
      actionableAdvice: suggestions.join(' '),
    );
  }

  @override
  Future<List<EligibilityResultEntity>> evaluateEligibility(EligibilityInputParams input) async {
    final response = await _apiClient.post('/eligibility/check', body: {
      'profile': _profile(input),
      'documents': [if (input.hasAadhaarLinkedBank) 'Aadhaar', if (input.hasAadhaarLinkedBank) 'Bank account details'],
    }) as Map<String, dynamic>;
    return (response['data'] as List<dynamic>? ?? []).map((item) => _result(Map<String, dynamic>.from(item as Map))).toList();
  }
  @override
  Future<void> saveCheckHistory(EligibilityInputParams input, List<EligibilityResultEntity> results) async {}
  @override
  Future<List<EligibilityHistoryEntity>> getCheckHistory() async {
    final response = await _apiClient.get('/eligibility/history') as Map<String, dynamic>;
    return (response['data'] as List<dynamic>? ?? []).map((item) {
      final data = Map<String, dynamic>.from(item as Map);
      return EligibilityHistoryEntity(id: data['id'].toString(), checkDate: DateTime.parse(data['createdAt'].toString()), state: '', crop: data['schemeName']?.toString() ?? 'Scheme check', totalEligibleCount: data['status'] == 'Eligible' ? 1 : 0, topSchemeNames: [data['schemeName']?.toString() ?? '']);
    }).toList();
  }
}
