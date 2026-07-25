import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';

import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_top_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppTopBar(title: loc.notifications),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            AppCard(
              child: ListTile(
                leading: const Icon(Icons.campaign_rounded, color: Colors.orange, size: 36.0),
                title: Text('PM-KISAN 16th Installment Released', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                subtitle: const Text('Eligible farmers can check bank credit status.'),
              ),
            ),
            AppCard(
              child: ListTile(
                leading: const Icon(Icons.shield_rounded, color: Colors.green, size: 36.0),
                title: Text('Crop Insurance Deadline Extended', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                subtitle: const Text('Apply before August 15 to secure Kharif crop coverage.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
