import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../common_widgets/app_card.dart';
import '../../providers/dashboard_providers.dart';
import '../../schemes/scheme_details_screen.dart';

class ContinueReadingWidget extends ConsumerWidget {
  const ContinueReadingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastScheme = ref.watch(continueReadingProvider);
    final theme = Theme.of(context);

    if (lastScheme == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Continue Reading',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          AppCard(
            margin: EdgeInsets.zero,
            backgroundColor: AppColors.accentLight.withOpacity(0.3),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SchemeDetailsScreen(schemeId: lastScheme.id),
                ),
              );
            },
            child: Row(
              children: [
                const Icon(Icons.history_edu_rounded, color: AppColors.accentDark, size: 36.0),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resume: ${lastScheme.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Tap to return to where you left off.',
                        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 28.0),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
