import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../common_widgets/app_card.dart';
import '../../../providers/dashboard_providers.dart';

class WeatherCardWidget extends ConsumerWidget {
  const WeatherCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final theme = Theme.of(context);

    return weatherAsync.when(
      data: (weather) {
        return AppCard(
          backgroundColor: AppColors.surfaceLight,
          elevation: AppConstants.elevationLow,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20.0),
                      const SizedBox(width: 4.0),
                      Text(
                        weather.locationName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Live Weather',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14.0),

              Row(
                children: [
                  const Icon(Icons.wb_sunny_rounded, size: 48.0, color: AppColors.accentDark),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.temperature.toInt()}°C',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackgroundLight,
                        ),
                      ),
                      Text(
                        weather.condition,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.outlineLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _WeatherMetric(icon: Icons.water_drop_outlined, label: '${weather.humidity}% Humidity'),
                      const SizedBox(height: 4.0),
                      _WeatherMetric(icon: Icons.air_rounded, label: '${weather.windSpeed} km/h Wind'),
                      const SizedBox(height: 4.0),
                      _WeatherMetric(icon: Icons.umbrella_outlined, label: '${weather.rainProbability}% Rain'),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24.0),

              // Today's Farming Advice
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.eco_rounded, color: AppColors.primary, size: 22.0),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Farming Advisory',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          weather.farmingAdvice,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.onBackgroundLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 160.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
      error: (err, stack) => const SizedBox(),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WeatherMetric({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.0, color: AppColors.outlineLight),
        const SizedBox(width: 4.0),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
        ),
      ],
    );
  }
}
