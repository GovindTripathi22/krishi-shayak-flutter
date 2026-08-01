import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../common_widgets/app_card.dart';
import '../../../providers/dashboard_providers.dart';
import '../../../providers/scheme_providers.dart';
import '../../schemes/scheme_details_screen.dart';

class LatestSchemesWidget extends ConsumerWidget {
  const LatestSchemesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemesState = ref.watch(schemesListNotifierProvider);
    final theme = Theme.of(context);

    if (schemesState.schemes.isEmpty) return const SizedBox();

    final latestList = schemesState.schemes.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          child: Text(
            'Latest Government Schemes',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          itemCount: latestList.length,
          itemBuilder: (context, index) {
            final scheme = latestList[index];
            return AppCard(
              margin: const EdgeInsets.only(bottom: 12.0),
              onTap: () {
                ref.read(continueReadingProvider.notifier).state = scheme;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SchemeDetailsScreen(schemeId: scheme.id),
                  ),
                );
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: const Icon(Icons.workspace_premium_rounded, color: AppColors.primary),
                ),
                title: Text(
                  scheme.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${scheme.category} • Deadline: ${scheme.deadline}',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
              ),
            );
          },
        ),
      ],
    );
  }
}
