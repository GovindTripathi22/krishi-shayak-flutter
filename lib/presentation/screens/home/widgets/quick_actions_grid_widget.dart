import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../common_widgets/app_card.dart';

class QuickActionsGridWidget extends StatelessWidget {
  const QuickActionsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actions = [
      _QuickItem(
        title: 'AI Chat',
        icon: Icons.smart_toy_rounded,
        color: AppColors.primaryContainer,
        iconColor: AppColors.primary,
        route: AppRoutes.aiChat,
      ),
      _QuickItem(
        title: 'Check Eligibility',
        icon: Icons.fact_check_rounded,
        color: AppColors.accentLight.withOpacity(0.5),
        iconColor: AppColors.accentDark,
        route: AppRoutes.eligibilityChecker,
      ),
      _QuickItem(
        title: 'Govt Schemes',
        icon: Icons.workspace_premium_rounded,
        color: AppColors.secondaryContainer,
        iconColor: AppColors.primaryDark,
        route: AppRoutes.schemes,
      ),
      _QuickItem(
        title: 'Upload PDF',
        icon: Icons.picture_as_pdf_rounded,
        color: Colors.red.shade50,
        iconColor: Colors.red.shade700,
        route: AppRoutes.pdfExplainer,
      ),
      _QuickItem(
        title: 'Bookmarks',
        icon: Icons.bookmark_rounded,
        color: Colors.purple.shade50,
        iconColor: Colors.purple.shade700,
        route: AppRoutes.bookmarks,
      ),
      _QuickItem(
        title: 'Voice Assistant',
        icon: Icons.mic_rounded,
        color: Colors.blue.shade50,
        iconColor: Colors.blue.shade700,
        route: AppRoutes.aiChat,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          child: Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12.0),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.95,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final item = actions[index];
            return AppCard(
              margin: EdgeInsets.zero,
              backgroundColor: item.color,
              onTap: () => context.push(item.route),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 22.0,
                    child: Icon(item.icon, color: item.iconColor, size: 24.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QuickItem {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final String route;

  const _QuickItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.route,
  });
}
