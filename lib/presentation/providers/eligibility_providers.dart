import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../domain/entities/eligibility_history_entity.dart';
import '../../domain/entities/eligibility_input_params.dart';
import '../../domain/entities/eligibility_result_entity.dart';
import '../../domain/repositories/eligibility_repository.dart';
import 'auth_controller_provider.dart';

// Input Questionnaire State Provider
final eligibilityInputsProvider = StateNotifierProvider<EligibilityInputsNotifier, EligibilityInputParams>((ref) {
  final profile = ref.watch(authControllerProvider).farmerProfile;
  if (profile != null) {
    return EligibilityInputsNotifier(
      EligibilityInputParams(
        state: profile.state.isNotEmpty ? profile.state : 'Maharashtra',
        district: profile.district.isNotEmpty ? profile.district : 'Nashik',
        village: profile.village.isNotEmpty ? profile.village : 'Pimplegaon',
        primaryCrop: profile.primaryCrop.isNotEmpty ? profile.primaryCrop : 'Wheat / Wheat',
        landSize: profile.landSize.isNotEmpty ? profile.landSize : '2.5 Acres',
        landOwnership: profile.landOwnership.isNotEmpty ? profile.landOwnership : 'Owned',
        annualIncome: profile.annualIncome.isNotEmpty ? profile.annualIncome : '₹1,50,000 - ₹3,00,000',
        farmerCategory: profile.farmerCategory.isNotEmpty ? profile.farmerCategory : 'Small Farmer',
        gender: profile.gender.isNotEmpty ? profile.gender : 'Male',
        age: profile.age > 0 ? profile.age : 42,
        irrigationType: profile.irrigationType.isNotEmpty ? profile.irrigationType : 'Drip Irrigation',
        isOrganicFarming: false,
        hasAadhaarLinkedBank: true,
        hasCropInsurance: true,
      ),
    );
  }
  return EligibilityInputsNotifier(EligibilityInputParams.defaultFarmer());
});

class EligibilityInputsNotifier extends StateNotifier<EligibilityInputParams> {
  EligibilityInputsNotifier(super.initialState);

  void updateState(String state) => this.state = this.state.copyWith(state: state);
  void updateCrop(String crop) => this.state = this.state.copyWith(primaryCrop: crop);
  void updateCategory(String category) => this.state = this.state.copyWith(farmerCategory: category);
  void toggleOrganic(bool val) => this.state = this.state.copyWith(isOrganicFarming: val);
  void toggleAadhaar(bool val) => this.state = this.state.copyWith(hasAadhaarLinkedBank: val);
  void toggleInsurance(bool val) => this.state = this.state.copyWith(hasCropInsurance: val);
}

// Evaluation State Notifier
class EligibilityState {
  final List<EligibilityResultEntity> results;
  final bool isEvaluating;
  final String? errorMessage;
  final bool hasEvaluated;

  const EligibilityState({
    this.results = const [],
    this.isEvaluating = false,
    this.errorMessage,
    this.hasEvaluated = false,
  });

  EligibilityState copyWith({
    List<EligibilityResultEntity>? results,
    bool? isEvaluating,
    String? errorMessage,
    bool? hasEvaluated,
  }) {
    return EligibilityState(
      results: results ?? this.results,
      isEvaluating: isEvaluating ?? this.isEvaluating,
      errorMessage: errorMessage,
      hasEvaluated: hasEvaluated ?? this.hasEvaluated,
    );
  }
}

final eligibilityEvaluationProvider =
    StateNotifierProvider<EligibilityEvaluationNotifier, EligibilityState>((ref) {
  return EligibilityEvaluationNotifier(repository: sl<EligibilityRepository>());
});

class EligibilityEvaluationNotifier extends StateNotifier<EligibilityState> {
  final EligibilityRepository repository;

  EligibilityEvaluationNotifier({required this.repository}) : super(const EligibilityState());

  Future<void> runEvaluation(EligibilityInputParams input) async {
    state = state.copyWith(isEvaluating: true, errorMessage: null);

    try {
      final results = await repository.evaluateEligibility(input);

      state = state.copyWith(
        results: results,
        isEvaluating: false,
        hasEvaluated: true,
      );
    } catch (e) {
      state = state.copyWith(
        isEvaluating: false,
        errorMessage: 'Rule evaluation failed. Please check internet connection or retry.',
      );
    }
  }

  void reset() {
    state = const EligibilityState();
  }
}

// History Provider
final eligibilityHistoryProvider = FutureProvider<List<EligibilityHistoryEntity>>((ref) async {
  final repo = sl<EligibilityRepository>();
  return await repo.getCheckHistory();
});
