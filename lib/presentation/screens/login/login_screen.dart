import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';

import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_dialog.dart';
import '../../common_widgets/app_text_field.dart';
import '../../common_widgets/app_top_bar.dart';
import '../auth_controller_provider.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+91';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).sendOtp(phone);
    if (success && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(phoneNumber: phone),
        ),
      );
    }
  }

  void _handleGoogleSignIn() async {
    final success = await ref.read(authControllerProvider.notifier).signInWithGoogle();
    if (success && mounted) {
      final authState = ref.read(authControllerProvider);
      if (authState.isProfileComplete) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.registrationWizard);
      }
    }
  }

  void _handleGuestLogin() async {
    AppDialog.show(
      context: context,
      title: 'Guest Mode Limitations',
      message: 'As a guest, you can explore general features, but you will need to create an account to save schemes, use AI PDF Explainer, or receive personalized eligibility updates.',
      primaryButtonText: 'Continue as Guest',
      onPrimaryPressed: () async {
        await ref.read(authControllerProvider.notifier).signInAsGuest();
        if (mounted) {
          context.go(AppRoutes.home);
        }
      },
      secondaryButtonText: 'Cancel',
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: loc.loginTitle,
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Brand Greeting
              AppCard(
                backgroundColor: AppColors.primaryContainer.withOpacity(0.5),
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Icon(Icons.eco_rounded, size: 48.0, color: AppColors.primary),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.welcomeTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            loc.welcomeSubtitle,
                            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28.0),

              // Phone Number Input with Country Code Selector
              Text(
                loc.phoneNumber,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56.0,
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(color: AppColors.outlineLight),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        items: const [
                          DropdownMenuItem(value: '+91', child: Text('🇮🇳 +91')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCountryCode = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: AppTextField(
                      label: '',
                      hintText: '98765 43210',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Send OTP Button
              AppButton(
                text: loc.sendOtp,
                icon: Icons.sms_rounded,
                isLoading: authState.isLoading,
                onPressed: _handleSendOtp,
              ),

              const SizedBox(height: 24.0),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('OR', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24.0),

              // Google Sign In Button
              AppButton(
                text: 'Sign in with Google',
                type: AppButtonType.secondary,
                icon: Icons.account_circle,
                onPressed: _handleGoogleSignIn,
              ),

              const SizedBox(height: 12.0),
              // Guest Login Button
              AppButton(
                text: 'Explore as Guest',
                type: AppButtonType.outlined,
                icon: Icons.person_outline_rounded,
                onPressed: _handleGuestLogin,
              ),

              const SizedBox(height: 32.0),
              // Legal Footer
              Center(
                child: Text(
                  'By logging in, you agree to KrishiSahayak\'s\nTerms of Service & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
