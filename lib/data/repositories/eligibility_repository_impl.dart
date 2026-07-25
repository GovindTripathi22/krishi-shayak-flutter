import 'dart:convert';

import '../../core/logger/app_logger.dart';
import '../../core/services/eligibility/eligibility_engine.dart';
import '../../core/services/storage/preferences_service.dart';
import '../../domain/entities/eligibility_history_entity.dart';
import '../../domain/entities/eligibility_input_params.dart';
import '../../domain/entities/eligibility_result_entity.dart';
import '../../domain/repositories/eligibility_repository.dart';
import '../../domain/repositories/government_scheme_repository.dart';
import '../models/eligibility_history_model.dart';

class EligibilityRepositoryImpl implements EligibilityRepository {
  final GovernmentSchemeRepository schemeRepository;
  static const String _keyHistory = 'pref_eligibility_history_v1';

  EligibilityRepositoryImpl({required this.schemeRepository});

  @override
  Future<List<EligibilityResultEntity>> evaluateEligibility(EligibilityInputParams input) async {
    AppLogger.info('EligibilityRepositoryImpl: Evaluating eligibility for state ${input.state}, crop ${input.primaryCrop}');
    final schemes = await schemeRepository.getSchemes(pageSize: 100);
    return EligibilityEngine.evaluateAll(schemes: schemes, input: input);
  }

  @override
  Future<void> saveCheckHistory(EligibilityInputParams input, List<EligibilityResultEntity> results) async {
    try {
      final historyList = await getCheckHistory();

      final topSchemes = results.take(3).map((r) => r.scheme.name).toList();
      final newHistory = EligibilityHistoryModel(
        id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
        checkDate: DateTime.now(),
        state: input.state,
        crop: input.primaryCrop,
        totalEligibleCount: results.where((r) => r.matchPercentage >= 60.0).length,
        topSchemeNames: topSchemes,
      );

      final updatedList = [newHistory, ...historyList.map((e) => EligibilityHistoryModel(
        id: e.id,
        checkDate: e.checkDate,
        state: e.state,
        crop: e.crop,
        totalEligibleCount: e.totalEligibleCount,
        topSchemeNames: e.topSchemeNames,
      ))];

      final jsonStr = jsonEncode(updatedList.map((h) => h.toJson()).toList());
      await PreferencesService.setString(_keyHistory, jsonStr);
      AppLogger.info('EligibilityRepositoryImpl: Saved eligibility check history');
    } catch (e, stack) {
      AppLogger.error('EligibilityRepositoryImpl: Error saving history', e, stack);
    }
  }

  @override
  Future<List<EligibilityHistoryEntity>> getCheckHistory() async {
    try {
      final rawStr = PreferencesService.getString(_keyHistory);
      if (rawStr != null && rawStr.isNotEmpty) {
        final List<dynamic> list = jsonDecode(rawStr);
        return list.map((j) => EligibilityHistoryModel.fromJson(j as Map<String, dynamic>)).toList();
      }
    } catch (e, stack) {
      AppLogger.error('EligibilityRepositoryImpl: Error reading history', e, stack);
    }
    return [];
  }
}
