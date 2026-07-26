import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/eligibility_input_params.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_top_bar.dart';
import '../providers/eligibility_providers.dart';

class EligibilityCheckerScreen extends ConsumerStatefulWidget {
  const EligibilityCheckerScreen({super.key});

  @override
  ConsumerState<EligibilityCheckerScreen> createState() => _EligibilityCheckerScreenState();
}

class _EligibilityCheckerScreenState extends ConsumerState<EligibilityCheckerScreen> {
  String selectedState = 'Maharashtra';
  String selectedDistrict = 'Nashik';
  String selectedCrop = 'Cotton';
  double landSizeInAcres = 3.0;
  String selectedCategory = 'Small Farmer';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = ref.watch(eligibilityEvaluationNotifierProvider);

    return Scaffold(
      appBar: const AppTopBar(title: 'AI Scheme Eligibility Engine'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Summary Banner
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16.0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI EVALUATION COMPLETE',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '5 Schemes Qualified!',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.extrabold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 54.0,
                          height: 54.0,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '98%',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'Total Potential Annual Benefit: ₹57,000 / year',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Filter Inputs Accordion Card
              AppCard(
                child: ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(
                    'Your Farm Profile Parameters',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'State: $selectedState • District: $selectedDistrict • Crop: $selectedCrop • Land: ${landSizeInAcres.toInt()} Acres',
                    style: theme.textTheme.bodySmall,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedState,
                            decoration: const InputDecoration(labelText: 'State'),
                            items: ['Maharashtra', 'Gujarat', 'Uttar Pradesh', 'Karnataka']
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (val) => setState(() => selectedState = val!),
                          ),
                          const SizedBox(height: 12.0),
                          DropdownButtonFormField<String>(
                            value: selectedCrop,
                            decoration: const InputDecoration(labelText: 'Primary Crop'),
                            items: ['Cotton', 'Wheat', 'Rice', 'Sugarcane']
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (val) => setState(() => selectedCrop = val!),
                          ),
                          const SizedBox(height: 16.0),
                          AppButton(
                            text: 'Re-Calculate Eligibility',
                            icon: Icons.auto_awesome_rounded,
                            onPressed: () {
                              ref.read(eligibilityEvaluationNotifierProvider.notifier).evaluate(
                                    EligibilityInputParams(
                                      state: selectedState,
                                      district: selectedDistrict,
                                      cropType: selectedCrop,
                                      landSizeInAcres: landSizeInAcres,
                                      farmerCategory: selectedCategory,
                                      annualIncome: 120000,
                                      age: 38,
                                      gender: 'Male',
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Results List Header
              Text(
                'Top Recommended Subsidies for You',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),

              // Scheme Result 1: PM-KISAN
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            '⭐ 98% Match',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.verified_rounded, color: AppColors.primary),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'PM-KISAN Samman Nidhi',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '₹6,000 / year Direct Cash Transfer',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why You Qualify:',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            '• Registered landholder in Nashik, Maharashtra\n• Active Aadhaar-seeded bank account verified',
                            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    AppButton(
                      text: 'Apply on Official Portal',
                      icon: Icons.open_in_new_rounded,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Scheme Result 2: SMAM
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            '88% Match',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'SMAM Tractor & Farm Machinery Subsidy',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Up to 50% Subsidy on Equipment (agrimachinery.nic.in)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    AppButton(
                      text: 'Apply on Official Portal',
                      type: AppButtonType.outlined,
                      icon: Icons.open_in_new_rounded,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
