import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/app_card.dart';
import '../../../providers/dashboard_providers.dart';
import '../../../providers/scheme_providers.dart';
import '../../schemes/scheme_details_screen.dart';

class RecommendedSchemesWidget extends ConsumerWidget {
  const RecommendedSchemesWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(recommendedSchemesProvider);
    final bookmarks = ref.watch(bookmarkNotifierProvider);
    final theme = Theme.of(context);
    return recommendations.when(
      loading: () => const SizedBox(), error: (_, __) => const SizedBox(),
      data: (items) {
        if (items.isEmpty) return const SizedBox();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium), child: Text('Recommended For You', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
          const SizedBox(height: 12),
          SizedBox(height: 240, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium), itemCount: items.length, itemBuilder: (context, index) {
            final recommendation = items[index]; final scheme = recommendation.scheme;
            return Container(width: MediaQuery.of(context).size.width * .78, margin: const EdgeInsets.only(right: 12), child: AppCard(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SchemeDetailsScreen(schemeId: scheme.id))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Chip(label: Text('${recommendation.matchPercentage.toStringAsFixed(0)}% · ${recommendation.eligibilityStatus}')), const Spacer(), IconButton(icon: Icon(bookmarks.contains(scheme.id) ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: AppColors.primary), onPressed: () => ref.read(bookmarkNotifierProvider.notifier).toggleBookmark(scheme.id))]),
                Text(scheme.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4), Text(scheme.benefits, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                if (recommendation.whyRecommended.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text(recommendation.whyRecommended.first, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall)),
                const Spacer(), AppButton(text: 'View & Apply', isFullWidth: false, onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SchemeDetailsScreen(schemeId: scheme.id)))),
              ]),
            ));
          })),
        ]);
      },
    );
  }
}
