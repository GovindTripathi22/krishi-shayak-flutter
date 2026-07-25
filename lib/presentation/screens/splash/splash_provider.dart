import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage/preferences_service.dart';
import '../../providers/auth_controller_provider.dart';

enum SplashNavigationTarget { onboarding, login, registrationWizard, home }

final splashNavigationProvider = FutureProvider<SplashNavigationTarget>((ref) async {
  await Future.delayed(AppConstants.splashDelay);

  final onboardingCompleted = PreferencesService.getBool(AppConstants.prefKeyOnboardingCompleted) ?? false;
  if (!onboardingCompleted) {
    return SplashNavigationTarget.onboarding;
  }

  final authNotifier = ref.read(authControllerProvider.notifier);
  await authNotifier.checkSession();

  final authState = ref.read(authControllerProvider);
  if (authState.isAuthenticated) {
    if (authState.isGuest || authState.isProfileComplete) {
      return SplashNavigationTarget.home;
    } else {
      return SplashNavigationTarget.registrationWizard;
    }
  }

  return SplashNavigationTarget.login;
});
