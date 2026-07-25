import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/language_selector_widget.dart';
import 'onboarding_provider.dart';

class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final Color iconBackgroundColor;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBackgroundColor,
  });
}

/// 3-Screen Farmer-Friendly Onboarding Flow with Smooth Page Animations
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onFinishOnboarding() async {
    await OnboardingController.completeOnboarding();
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final activeIndex = ref.watch(onboardingPageIndexProvider);

    final pages = [
      OnboardingPageData(
        title: loc.welcomeTitle,
        description: loc.welcomeSubtitle,
        icon: Icons.agriculture_rounded,
        iconBackgroundColor: AppColors.primaryContainer,
      ),
      OnboardingPageData(
        title: loc.onboarding1Title,
        description: loc.onboarding1Desc,
        icon: Icons.verified_user_rounded,
        iconBackgroundColor: AppColors.secondaryContainer,
      ),
      OnboardingPageData(
        title: loc.onboarding3Title,
        description: loc.onboarding3Desc,
        icon: Icons.record_voice_over_rounded,
        iconBackgroundColor: AppColors.accentLight.withOpacity(0.5),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.translate_rounded, color: AppColors.primary),
            onPressed: () => LanguageSelectorWidget.showLanguageModal(context),
            tooltip: 'Change Language',
          ),
          if (activeIndex < pages.length - 1)
            TextButton(
              onPressed: _onFinishOnboarding,
              child: Text(
                loc.skip,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.outlineLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  ref.read(onboardingPageIndexProvider.notifier).state = index;
                },
                itemBuilder: (context, index) {
                  final data = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160.0,
                          height: 160.0,
                          decoration: BoxDecoration(
                            color: data.iconBackgroundColor,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowLight,
                                blurRadius: 12.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            data.icon,
                            size: 80.0,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onBackgroundLight,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.outlineLight,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: AppConstants.durationNormal,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8.0,
                  width: activeIndex == index ? 24.0 : 8.0,
                  decoration: BoxDecoration(
                    color: activeIndex == index ? AppColors.primary : AppColors.outlineLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // Bottom Actions
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: AppButton(
                text: activeIndex == pages.length - 1 ? loc.getStarted : loc.next,
                icon: activeIndex == pages.length - 1 ? Icons.check_circle_outline : Icons.arrow_forward_rounded,
                onPressed: () {
                  if (activeIndex < pages.length - 1) {
                    _pageController.nextPage(
                      duration: AppConstants.durationNormal,
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _onFinishOnboarding();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
