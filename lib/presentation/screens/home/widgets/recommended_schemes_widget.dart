import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/app_card.dart';
import '../../providers/dashboard_providers.dart';
import '../../providers/scheme_providers.dart';
import '../../schemes/scheme_details_screen.dart';

class RecommendedSchemesWidget extends ConsumerWidget {
  const RecommendedSchemesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedAsync = ref.watch(recommendedSchemesProvider);
    final bookmarkedIds = ref.watch(bookmarkNotifierProvider);
    final theme = Theme.of(context);

    return recommendedAsync.when(
      data: (schemes) {
        if (schemes.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended For You',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tailored to your crops',
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            SizedBox(
              height: 230.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                itemCount: schemes.length,
                itemBuilder: (context, index) {
                  final scheme = schemes[index];
                  final isBkm = bookmarkedIds.contains(scheme.id);

                  return Container(
                    width: MediaQuery.of(context).size.width * 0.78,
                    margin: const EdgeInsets.only(right: 12.0),
                    child: AppCard(
                      margin: EdgeInsets.zero,
                      onTap: () {
                        ref.read(continueReadingProvider.notifier).state = scheme;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SchemeDetailsScreen(schemeId: scheme.id),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  '⭐ Why: High Crop Match',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  isBkm ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                  color: isBkm ? AppColors.primary : AppColors.outlineLight,
                                ),
                                onPressed: () {
                                  ref.read(bookmarkNotifierProvider.notifier).toggleBookmark(scheme.id);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            scheme.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            scheme.benefits,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Deadline: ${scheme.deadline}',
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange.shade800),
                              ),
                              AppButton(
                                text: 'View & Apply',
                                isFullWidth: false,
                                onPressed: () {
                                  ref.read(continueReadingProvider.notifier).state = scheme;
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SchemeDetailsScreen(schemeId: scheme.id),
                                    ),
                                  );
                                },
                              ),
                            ],
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
      },
      loading: () => const SizedBox(),
      error: (err, stack) => const SizedBox(),
    );
  }
}
