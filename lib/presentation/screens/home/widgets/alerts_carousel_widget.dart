import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/farmer_alert_entity.dart';
import '../../../common_widgets/app_card.dart';
import '../../../providers/dashboard_providers.dart';

class AlertsCarouselWidget extends ConsumerWidget {
  const AlertsCarouselWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertsNotifierProvider);
    final activeAlerts = alerts.where((a) => !a.isDismissed).toList();
    final theme = Theme.of(context);

    if (activeAlerts.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          child: Text(
            'Today\'s Alerts',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 110.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
            itemCount: activeAlerts.length,
            itemBuilder: (context, index) {
              final alert = activeAlerts[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: const EdgeInsets.only(right: 12.0),
                child: AppCard(
                  margin: EdgeInsets.zero,
                  backgroundColor: _getAlertBgColor(alert.type),
                  child: Row(
                    children: [
                      Icon(_getAlertIcon(alert.type), size: 36.0, color: _getAlertIconColor(alert.type)),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              alert.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              alert.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.onBackgroundLight.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18.0),
                        onPressed: () {
                          ref.read(alertsNotifierProvider.notifier).dismissAlert(alert.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getAlertBgColor(AlertType type) {
    switch (type) {
      case AlertType.payment:
        return AppColors.primaryContainer.withOpacity(0.6);
      case AlertType.deadline:
        return Colors.orange.shade50;
      case AlertType.heavyRain:
        return Colors.blue.shade50;
      case AlertType.diseaseWarning:
        return Colors.red.shade50;
      case AlertType.announcement:
      default:
        return AppColors.secondaryContainer;
    }
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.payment:
        return Icons.account_balance_wallet_rounded;
      case AlertType.deadline:
        return Icons.alarm_rounded;
      case AlertType.heavyRain:
        return Icons.thunderstorm_rounded;
      case AlertType.diseaseWarning:
        return Icons.bug_report_rounded;
      case AlertType.announcement:
      default:
        return Icons.campaign_rounded;
    }
  }

  Color _getAlertIconColor(AlertType type) {
    switch (type) {
      case AlertType.payment:
        return AppColors.primary;
      case AlertType.deadline:
        return Colors.orange.shade800;
      case AlertType.heavyRain:
        return Colors.blue.shade800;
      case AlertType.diseaseWarning:
        return Colors.red.shade700;
      case AlertType.announcement:
      default:
        return AppColors.primaryDark;
    }
  }
}
