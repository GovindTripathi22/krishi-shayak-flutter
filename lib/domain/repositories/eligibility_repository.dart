import '../entities/eligibility_history_entity.dart';
import '../entities/eligibility_input_params.dart';
import '../entities/eligibility_result_entity.dart';

abstract class EligibilityRepository {
  Future<List<EligibilityResultEntity>> evaluateEligibility(EligibilityInputParams input);
  Future<void> saveCheckHistory(EligibilityInputParams input, List<EligibilityResultEntity> results);
  Future<List<EligibilityHistoryEntity>> getCheckHistory();
}
