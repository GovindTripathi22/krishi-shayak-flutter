import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage/preferences_service.dart';

final onboardingPageIndexProvider = StateProvider<int>((ref) => 0);

class OnboardingController {
  static Future<void> completeOnboarding() async {
    await PreferencesService.setBool(AppConstants.prefKeyOnboardingCompleted, true);
  }
}
