import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/services/network/connectivity_service.dart';
import '../../common_widgets/app_bottom_navigation.dart';
import '../../common_widgets/app_search_bar.dart';
import '../../providers/auth_controller_provider.dart';
import '../../providers/dashboard_providers.dart';
import '../../providers/scheme_providers.dart';
import 'widgets/alerts_carousel_widget.dart';
import 'widgets/continue_reading_widget.dart';
import 'widgets/latest_schemes_widget.dart';
import 'widgets/quick_actions_grid_widget.dart';
import 'widgets/recommended_schemes_widget.dart';
import 'widgets/weather_card_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final timeGreeting = ref.watch(timeGreetingProvider);
    final authState = ref.watch(authControllerProvider);
    final networkStatus = ref.watch(connectivityProvider);
    final farmerName = authState.farmerProfile?.fullName.isNotEmpty == true
        ? authState.farmerProfile!.fullName.split(' ').first
        : 'Farmer Friend';

    return Scaffold(
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            // Real-Time Offline Banner
            if (networkStatus == NetworkStatus.offline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                color: Colors.orange.shade800,
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18.0),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'You are Offline. Showing cached weather & schemes.',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            // Top Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: const CircleAvatar(
                      radius: 22.0,
                      backgroundColor: AppColors.primaryContainer,
                      child: Icon(Icons.person, color: AppColors.primary, size: 26.0),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$timeGreeting, $farmerName 👋',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onBackgroundLight,
                          ),
                        ),
                        Text(
                          'Let\'s find the best schemes for your farm.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.outlineLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications_outlined, size: 28.0),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 9.0, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => context.push(AppRoutes.notifications),
                  ),
                ],
              ),
            ),

            // Search Bar & Body
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(weatherProvider);
                  await ref.read(schemesListNotifierProvider.notifier).fetchSchemes(refresh: true);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        child: AppSearchBar(
                          hintText: loc.searchPlaceholder,
                          onSubmitted: (val) {
                            ref.read(searchQueryProvider.notifier).state = val;
                            context.push(AppRoutes.schemes);
                          },
                          onVoicePressed: () {
                            context.push(AppRoutes.aiChat);
                          },
                        ),
                      ),

                      // Weather Advisory Card
                      const WeatherCardWidget(),
                      const SizedBox(height: 20.0),

                      // Today's Alerts Carousel
                      const AlertsCarouselWidget(),
                      const SizedBox(height: 24.0),

                      // Quick Action Grid (2-Tap Farmer Navigation)
                      const QuickActionsGridWidget(),
                      const SizedBox(height: 24.0),

                      // Continue Reading Resume Session
                      const ContinueReadingWidget(),

                      // Recommended Schemes Carousel
                      const RecommendedSchemesWidget(),
                      const SizedBox(height: 24.0),

                      // Latest Schemes List
                      const LatestSchemesWidget(),
                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
