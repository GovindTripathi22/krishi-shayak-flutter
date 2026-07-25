import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import 'app_button.dart';

/// Reusable Empty State Display Component
class AppEmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;

  const AppEmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.inbox_outlined,
    this.actionButtonText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.outlineLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionButtonText != null && onActionPressed != null) ...[
              const SizedBox(height: 24.0),
              AppButton(
                text: actionButtonText!,
                onPressed: onActionPressed,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
