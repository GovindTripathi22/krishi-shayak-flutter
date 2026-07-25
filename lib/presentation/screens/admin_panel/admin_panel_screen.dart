import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';

import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_top_bar.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppTopBar(title: loc.adminPanel),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scheme Management & AI Analytics',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              AppCard(
                child: ListTile(
                  leading: const Icon(Icons.add_task_rounded, color: Colors.blue),
                  title: Text('Add New Government Scheme', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Upload scheme details, eligibility guidelines & PDF documents.'),
                ),
              ),
              AppCard(
                child: ListTile(
                  leading: const Icon(Icons.insights_rounded, color: Colors.purple),
                  title: Text('AI Query Analytics', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Track most asked farmer questions and regional scheme demands.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
