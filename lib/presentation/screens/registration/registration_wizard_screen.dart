import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_text_field.dart';
import '../../common_widgets/app_top_bar.dart';
import '../../providers/auth_controller_provider.dart';
import 'registration_provider.dart';

class RegistrationWizardScreen extends ConsumerStatefulWidget {
  const RegistrationWizardScreen({super.key});

  @override
  ConsumerState<RegistrationWizardScreen> createState() => _RegistrationWizardScreenState();
}

class _RegistrationWizardScreenState extends ConsumerState<RegistrationWizardScreen> {
  final PageController _pageController = PageController();

  final TextEditingController _nameController = TextEditingController(text: 'Ramesh Patel');
  final TextEditingController _ageController = TextEditingController(text: '42');
  final TextEditingController _villageController = TextEditingController(text: 'Pimplegaon');
  final TextEditingController _pincodeController = TextEditingController(text: '422209');

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _villageController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    final current = ref.read(registrationDraftProvider).currentStep;
    if (current < 4) {
      ref.read(registrationDraftProvider.notifier).setStep(current + 1);
      _pageController.animateToPage(
        current + 1,
        duration: AppConstants.durationNormal,
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    final current = ref.read(registrationDraftProvider).currentStep;
    if (current > 0) {
      ref.read(registrationDraftProvider.notifier).setStep(current - 1);
      _pageController.animateToPage(
        current - 1,
        duration: AppConstants.durationNormal,
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitProfile() async {
    final draft = ref.read(registrationDraftProvider);
    final authState = ref.read(authControllerProvider);
    final userId = authState.user?.id ?? 'usr_101';
    final provider = authState.user != null ? 'phone' : 'guest';

    final profile = draft.toEntity(userId, provider);
    await ref.read(authControllerProvider.notifier).updateFarmerProfile(profile);

    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final draft = ref.watch(registrationDraftProvider);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: 'Farmer Profile Setup',
        showBackButton: draft.currentStep > 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Step ${draft.currentStep + 1} of 5',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Indicator
            LinearProgressIndicator(
              value: (draft.currentStep + 1) / 5.0,
              backgroundColor: AppColors.primaryContainer.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1Personal(theme, draft),
                  _buildStep2Location(theme, draft),
                  _buildStep3Farming(theme, draft),
                  _buildStep4Permissions(theme, draft),
                  _buildStep5Review(theme, draft),
                ],
              ),
            ),

            // Bottom Navigation Actions
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: const [
                  BoxShadow(color: AppColors.shadowLight, blurRadius: 6.0, offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  if (draft.currentStep > 0)
                    Expanded(
                      child: AppButton(
                        text: 'Back',
                        type: AppButtonType.outlined,
                        onPressed: _prevStep,
                      ),
                    ),
                  if (draft.currentStep > 0) const SizedBox(width: 12.0),
                  Expanded(
                    child: AppButton(
                      text: draft.currentStep == 4 ? 'Confirm & Finish' : 'Next Step',
                      icon: draft.currentStep == 4 ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
                      isLoading: authState.isLoading,
                      onPressed: draft.currentStep == 4 ? _submitProfile : _nextStep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 1: Personal Details
  Widget _buildStep1Personal(ThemeData theme, RegistrationDraftState draft) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 1: Personal Details', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6.0),
          Text('Tell us about yourself to customize your profile.', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.outlineLight)),
          const SizedBox(height: 24.0),

          AppTextField(
            label: 'Full Name',
            controller: _nameController,
            onChanged: (val) => ref.read(registrationDraftProvider.notifier).updatePersonal(fullName: val),
          ),
          const SizedBox(height: 16.0),

          AppTextField(
            label: 'Age',
            controller: _ageController,
            keyboardType: TextInputType.number,
            onChanged: (val) => ref.read(registrationDraftProvider.notifier).updatePersonal(age: int.tryParse(val) ?? 35),
          ),
          const SizedBox(height: 16.0),

          Text('Gender', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Row(
            children: ['Male', 'Female', 'Other'].map((g) {
              final isSel = draft.gender == g;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(g),
                  selected: isSel,
                  selectedColor: AppColors.primaryContainer,
                  onSelected: (sel) {
                    if (sel) ref.read(registrationDraftProvider.notifier).updatePersonal(gender: g);
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // STEP 2: Location Details
  Widget _buildStep2Location(ThemeData theme, RegistrationDraftState draft) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 2: Location Details', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6.0),
          Text('Location helps us find state & district specific schemes.', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.outlineLight)),
          const SizedBox(height: 24.0),

          Text('State', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6.0),
          DropdownButton<String>(
            value: draft.state,
            isExpanded: true,
            items: ['Maharashtra', 'Uttar Pradesh', 'Punjab', 'Gujarat', 'Tamil Nadu', 'Karnataka', 'Telangana']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (val) {
              if (val != null) ref.read(registrationDraftProvider.notifier).updateLocation(stateName: val);
            },
          ),
          const SizedBox(height: 16.0),

          Text('District', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6.0),
          DropdownButton<String>(
            value: draft.district,
            isExpanded: true,
            items: ['Nashik', 'Pune', 'Latur', 'Nagpur', 'Ahmednagar']
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (val) {
              if (val != null) ref.read(registrationDraftProvider.notifier).updateLocation(district: val);
            },
          ),
          const SizedBox(height: 16.0),

          AppTextField(
            label: 'Village / Town',
            controller: _villageController,
            onChanged: (val) => ref.read(registrationDraftProvider.notifier).updateLocation(village: val),
          ),
          const SizedBox(height: 16.0),

          AppTextField(
            label: 'Pin Code',
            controller: _pincodeController,
            keyboardType: TextInputType.number,
            onChanged: (val) => ref.read(registrationDraftProvider.notifier).updateLocation(pincode: val),
          ),
        ],
      ),
    );
  }

  // STEP 3: Farming Details
  Widget _buildStep3Farming(ThemeData theme, RegistrationDraftState draft) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 3: Farming Profile', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6.0),
          Text('Crop details help filter relevant subsidies.', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.outlineLight)),
          const SizedBox(height: 24.0),

          Text('Primary Crop', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6.0),
          DropdownButton<String>(
            value: draft.primaryCrop,
            isExpanded: true,
            items: ['Wheat / Wheat', 'Rice / Paddy', 'Cotton', 'Sugarcane', 'Soybean', 'Maize']
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (val) {
              if (val != null) ref.read(registrationDraftProvider.notifier).updateFarming(primaryCrop: val);
            },
          ),
          const SizedBox(height: 16.0),

          Text('Land Size', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: ['< 1 Acre', '1 - 2.5 Acres', '2.5 - 5 Acres', '5+ Acres'].map((ls) {
              final isSel = draft.landSize == ls;
              return ChoiceChip(
                label: Text(ls),
                selected: isSel,
                selectedColor: AppColors.primaryContainer,
                onSelected: (sel) {
                  if (sel) ref.read(registrationDraftProvider.notifier).updateFarming(landSize: ls);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16.0),

          Text('Farmer Category', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6.0),
          DropdownButton<String>(
            value: draft.farmerCategory,
            isExpanded: true,
            items: ['Small Farmer', 'Marginal Farmer', 'General Farmer', 'Women Farmer']
                .map((fc) => DropdownMenuItem(value: fc, child: Text(fc)))
                .toList(),
            onChanged: (val) {
              if (val != null) ref.read(registrationDraftProvider.notifier).updateFarming(farmerCategory: val);
            },
          ),
        ],
      ),
    );
  }

  // STEP 4: Permissions Explanation
  Widget _buildStep4Permissions(ThemeData theme, RegistrationDraftState draft) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 4: App Permissions', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6.0),
          Text('Enable permissions for a seamless AI experience.', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.outlineLight)),
          const SizedBox(height: 24.0),

          _PermissionTile(
            title: 'Location Access',
            subtitle: 'To show weather alerts and nearby Krishi Vigyan Kendra centers.',
            icon: Icons.location_on_rounded,
            value: draft.locationPermission,
            onChanged: (val) => ref.read(registrationDraftProvider.notifier).togglePermission('location', val),
          ),
          _PermissionTile(
            title: 'Notifications',
            subtitle: 'For instant updates on new subsidy schemes and payment credits.',
            icon: Icons.notifications_active_rounded,
            value: draft.notificationPermission,
            onChanged: (val) => ref.read(registrationDraftProvider.notifier).togglePermission('notification', val),
          ),
          _PermissionTile(
            title: 'Microphone',
            subtitle: 'To enable hands-free voice search in your regional language.',
            icon: Icons.mic_rounded,
            value: draft.micPermission,
            onChanged: (val) => ref.read(registrationDraftProvider.notifier).togglePermission('mic', val),
          ),
          _PermissionTile(
            title: 'Storage & Camera',
            subtitle: 'To upload government circular PDFs and crop disease photos.',
            icon: Icons.camera_alt_rounded,
            value: draft.cameraPermission,
            onChanged: (val) => ref.read(registrationDraftProvider.notifier).togglePermission('camera', val),
          ),
        ],
      ),
    );
  }

  // STEP 5: Review & Confirm
  Widget _buildStep5Review(ThemeData theme, RegistrationDraftState draft) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 5: Profile Summary', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6.0),
          Text('Review your details before saving.', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.outlineLight)),
          const SizedBox(height: 20.0),

          AppCard(
            backgroundColor: AppColors.primaryContainer.withOpacity(0.4),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: AppColors.primary, size: 36.0),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profile Completion: 100%', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const Text('All mandatory information has been provided.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ReviewRow(label: 'Full Name', value: _nameController.text),
                _ReviewRow(label: 'Gender / Age', value: '${draft.gender}, ${_ageController.text} yrs'),
                _ReviewRow(label: 'State & District', value: '${draft.state}, ${draft.district}'),
                _ReviewRow(label: 'Primary Crop', value: draft.primaryCrop),
                _ReviewRow(label: 'Land Size', value: draft.landSize),
                _ReviewRow(label: 'Category', value: draft.farmerCategory),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PermissionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: SwitchListTile(
        title: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight)),
        secondary: Icon(icon, color: AppColors.primary),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
