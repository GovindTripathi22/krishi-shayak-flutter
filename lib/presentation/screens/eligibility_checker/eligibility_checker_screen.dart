import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/eligibility_result_entity.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_empty_state_widget.dart';
import '../../common_widgets/app_error_widget.dart';
import '../../common_widgets/app_loading_indicator.dart';
import '../../common_widgets/app_top_bar.dart';
import '../../providers/eligibility_providers.dart';

class EligibilityCheckerScreen extends ConsumerWidget {
  const EligibilityCheckerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(eligibilityInputsProvider);
    final evaluation = ref.watch(eligibilityEvaluationProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const AppTopBar(title: 'Scheme Eligibility'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Your farm profile', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('State: ${input.state}\nDistrict: ${input.district}\nCrop: ${input.primaryCrop}\nLand: ${input.landSize}'),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Check eligibility', icon: Icons.fact_check_outlined,
                  onPressed: evaluation.isEvaluating ? null : () => ref.read(eligibilityEvaluationProvider.notifier).runEvaluation(input),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            if (evaluation.isEvaluating) const AppLoadingIndicator(message: 'Checking current scheme requirements...')
            else if (evaluation.errorMessage != null) AppErrorWidget(errorMessage: evaluation.errorMessage!, onRetry: () => ref.read(eligibilityEvaluationProvider.notifier).runEvaluation(input))
            else if (!evaluation.hasEvaluated) const AppEmptyStateWidget(title: 'Check your eligibility', description: 'We will compare your saved farm profile with current scheme rules.', icon: Icons.assignment_turned_in_outlined)
            else if (evaluation.results.isEmpty) const AppEmptyStateWidget(title: 'No active schemes found', description: 'Try again later or update your profile.', icon: Icons.search_off_rounded)
            else ...[
              Text('Eligibility results', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...evaluation.results.map((result) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(result.scheme.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                    Chip(label: Text('${result.matchPercentage.toStringAsFixed(0)}% · ${result.categoryTag.label}')),
                  ]),
                  const SizedBox(height: 6),
                  Text(result.scheme.benefits, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  if (result.whyEligible.isNotEmpty) ...[const SizedBox(height: 10), Text(result.whyEligible.join('\n'))],
                  if (result.whyIneligible.isNotEmpty) ...[const SizedBox(height: 10), Text('Missing criteria: ${result.whyIneligible.join('; ')}')],
                  if (result.missingDocuments.isNotEmpty) ...[const SizedBox(height: 8), Text('Missing documents: ${result.missingDocuments.join(', ')}')],
                  if (result.actionableAdvice.isNotEmpty) ...[const SizedBox(height: 10), Text(result.actionableAdvice)],
                ])),
              )),
            ],
          ]),
        ),
      ),
    );
  }
}
