import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';

import '../../../domain/entities/eligibility_input_params.dart';
import '../../../domain/entities/eligibility_result_entity.dart';
import '../../common_widgets/app_bottom_navigation.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_loading_indicator.dart';
import '../../common_widgets/app_top_bar.dart';
import '../providers/eligibility_providers.dart';
import '../schemes/scheme_details_screen.dart';

class EligibilityCheckerScreen extends ConsumerStatefulWidget {
  const EligibilityCheckerScreen({super.key});

  @override
  ConsumerState<EligibilityCheckerScreen> createState() => _EligibilityCheckerScreenState();
}

class _EligibilityCheckerScreenState extends ConsumerState<EligibilityCheckerScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final evalState = ref.watch(eligibilityEvaluationProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: loc.eligibilityChecker,
        actions: [
          if (evalState.hasEvaluated)
            TextButton(
              onPressed: () {
                ref.read(eligibilityEvaluationProvider.notifier).reset();
              },
              child: const Text('Re-evaluate', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(width: 8.0),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
      body: SafeArea(
        child: evalState.isEvaluating
            ? const Center(child: AppLoadingIndicator(message: 'AI Engine is evaluating 150+ scheme rules...'))
            : evalState.hasEvaluated
                ? _buildResultsView(context, evalState.results)
                : _buildInputView(context),
      ),
    );
  }

  // STEP 1 & 2: Input Questionnaire View
  Widget _buildInputView(BuildContext context) {
    final theme = Theme.of(context);
    final inputs = ref.watch(eligibilityInputsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check Scheme Eligibility in Seconds',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6.0),
          Text(
            'Our AI compares your profile against official government eligibility criteria and explains why you qualify.',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.outlineLight),
          ),
          const SizedBox(height: 24.0),

          // Auto-Filled Profile Card
          AppCard(
            backgroundColor: AppColors.primaryContainer.withOpacity(0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_pin_rounded, color: AppColors.primary),
                    const SizedBox(width: 8.0),
                    Text('Auto-Filled From Your Profile', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12.0),
                _InputRow(label: 'State & District', value: '${inputs.state}, ${inputs.district}'),
                _InputRow(label: 'Primary Crop', value: inputs.primaryCrop),
                _InputRow(label: 'Land Holding', value: inputs.landSize),
                _InputRow(label: 'Farmer Category', value: inputs.farmerCategory),
              ],
            ),
          ),
          const SizedBox(height: 20.0),

          // Additional Questions Card
          Text('Additional Requirements', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Aadhaar-Linked Bank Account', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Required for 100% Direct Benefit Transfer (DBT)'),
                  value: inputs.hasAadhaarLinkedBank,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(eligibilityInputsProvider.notifier).toggleAadhaar(val);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Organic Farming Practice', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Qualifies for PKVY organic subsidies'),
                  value: inputs.isOrganicFarming,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(eligibilityInputsProvider.notifier).toggleOrganic(val);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Crop Insurance Active', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Qualifies for additional PMFBY bonus schemes'),
                  value: inputs.hasCropInsurance,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(eligibilityInputsProvider.notifier).toggleInsurance(val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32.0),
          AppButton(
            text: 'Run AI Eligibility Evaluation',
            icon: Icons.psychology_rounded,
            onPressed: () {
              ref.read(eligibilityEvaluationProvider.notifier).runEvaluation(inputs);
            },
          ),
        ],
      ),
    );
  }

  // STEP 3: Results View
  Widget _buildResultsView(BuildContext context, List<EligibilityResultEntity> results) {
    final theme = Theme.of(context);
    final eligibleCount = results.where((r) => r.matchPercentage >= 65.0).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          AppCard(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, size: 56.0, color: AppColors.accent),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You Qualify for $eligibleCount Schemes!',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'AI Engine matched your farm profile against 150+ central & state subsidies.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),

          Text('Personalized Scheme Breakdown', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12.0),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return _ResultCard(result: result);
            },
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final EligibilityResultEntity result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = result.scheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        leading: Container(
          width: 54.0,
          height: 54.0,
          decoration: BoxDecoration(
            color: _getMatchColor(result.matchPercentage).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${result.matchPercentage.toInt()}%',
              style: TextStyle(
                color: _getMatchColor(result.matchPercentage),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        title: Text(
          scheme.name,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            Text(scheme.benefits, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: _getMatchColor(result.matchPercentage).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                result.categoryTag.label,
                style: TextStyle(
                  color: _getMatchColor(result.matchPercentage),
                  fontWeight: FontWeight.bold,
                  fontSize: 11.0,
                ),
              ),
            ),
          ],
        ),
        children: [
          const Divider(height: 16.0),

          // WHY YOU ARE ELIGIBLE
          if (result.whyEligible.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Why You Qualify:', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                  const SizedBox(height: 4.0),
                  ...result.whyEligible.map((re) => Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 16.0),
                          const SizedBox(width: 8.0),
                          Expanded(child: Text(re, style: theme.textTheme.bodyMedium)),
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
          ],

          // MISSING DOCUMENTS / UNMET REQUIREMENTS
          if (result.whyIneligible.isNotEmpty || result.missingDocuments.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Missing Requirements / Documents:', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.orange.shade900)),
                  const SizedBox(height: 4.0),
                  ...result.whyIneligible.map((ie) => Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16.0),
                          const SizedBox(width: 8.0),
                          Expanded(child: Text(ie, style: theme.textTheme.bodyMedium)),
                        ],
                      )),
                  ...result.missingDocuments.map((doc) => Row(
                        children: [
                          const Icon(Icons.description_outlined, color: Colors.orange, size: 16.0),
                          const SizedBox(width: 8.0),
                          Expanded(child: Text('Document Required: $doc', style: theme.textTheme.bodyMedium)),
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
          ],

          // AI ACTIONABLE ADVICE
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primaryDark, size: 20.0),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    result.actionableAdvice,
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          AppButton(
            text: 'View Scheme Details',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SchemeDetailsScreen(schemeId: scheme.id),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getMatchColor(double pct) {
    if (pct >= 85.0) return AppColors.primary;
    if (pct >= 65.0) return Colors.blue.shade700;
    if (pct >= 40.0) return Colors.orange.shade800;
    return AppColors.error;
  }
}

class _InputRow extends StatelessWidget {
  final String label;
  final String value;

  const _InputRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.outlineLight)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
