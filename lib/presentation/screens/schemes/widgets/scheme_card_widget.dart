import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/government_scheme_entity.dart';
import '../../../common_widgets/app_card.dart';
import '../../providers/scheme_providers.dart';

class SchemeCardWidget extends ConsumerWidget {
  final GovernmentSchemeEntity scheme;
  final VoidCallback onTap;

  const SchemeCardWidget({
    super.key,
    required this.scheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bookmarkedIds = ref.watch(bookmarkNotifierProvider);
    final isBookmarked = bookmarkedIds.contains(scheme.id);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: scheme.isCentralScheme ? AppColors.primaryContainer : AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  scheme.isCentralScheme ? 'Central Scheme' : 'State Scheme',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.isCentralScheme ? AppColors.primaryDark : AppColors.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.accentLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  scheme.category,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.accentDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isBookmarked ? AppColors.primary : AppColors.outlineLight,
                ),
                onPressed: () {
                  ref.read(bookmarkNotifierProvider.notifier).toggleBookmark(scheme.id);
                },
                tooltip: 'Bookmark Scheme',
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          Text(
            scheme.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6.0),

          Text(
            scheme.shortDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.outlineLight,
            ),
          ),
          const SizedBox(height: 14.0),

          Row(
            children: [
              const Icon(Icons.verified_rounded, size: 16.0, color: AppColors.primary),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  scheme.financialAssistance,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Deadline: ${scheme.deadline}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
