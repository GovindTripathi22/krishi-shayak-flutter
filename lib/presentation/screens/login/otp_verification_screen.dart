import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_text_field.dart';
import '../../common_widgets/app_top_bar.dart';
import '../../providers/auth_controller_provider.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid 6-digit OTP')),
      );
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).verifyOtp(widget.phoneNumber, otp);
    if (success && mounted) {
      final authState = ref.read(authControllerProvider);
      if (authState.isProfileComplete) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.registrationWizard);
      }
    }
  }

  void _handleResendOtp() async {
    if (!_canResend) return;
    await ref.read(authControllerProvider.notifier).sendOtp(widget.phoneNumber);
    _startTimer();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A new OTP has been sent to your mobile number.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppTopBar(title: 'Verify OTP'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Verification Code',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'We sent a 6-digit OTP code to +91 ${widget.phoneNumber}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.outlineLight,
                ),
              ),
              const SizedBox(height: 32.0),

              AppTextField(
                label: 'OTP Code',
                hintText: '• • • • • •',
                controller: _otpController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.lock_clock_rounded, color: AppColors.primary),
              ),

              if (authState.errorMessage != null) ...[
                const SizedBox(height: 12.0),
                Text(
                  authState.errorMessage!,
                  style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                ),
              ],

              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _canResend ? 'Didn\'t receive OTP?' : 'Resend code in ${_secondsRemaining}s',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.outlineLight,
                    ),
                  ),
                  TextButton(
                    onPressed: _canResend ? _handleResendOtp : null,
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _canResend ? AppColors.primary : AppColors.outlineLight,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40.0),
              AppButton(
                text: 'Verify & Continue',
                icon: Icons.check_circle_rounded,
                isLoading: authState.isLoading,
                onPressed: _handleVerifyOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
