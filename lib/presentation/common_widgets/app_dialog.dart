import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import 'app_button.dart';

/// Reusable Farmer-Friendly Dialog Component with Clear Typography and Big Buttons
class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final IconData? icon;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.icon,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    String? primaryButtonText,
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    IconData? icon,
  }) {
    return showDialog<T>(
      context: context,
      builder: (ctx) => AppDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        secondaryButtonText: secondaryButtonText,
        onSecondaryPressed: onSecondaryPressed,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      contentPadding: const EdgeInsets.all(AppConstants.paddingLarge),
      title: Column(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 48.0, color: theme.colorScheme.primary),
            const SizedBox(height: 12.0),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyLarge,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Column(
          children: [
            if (primaryButtonText != null)
              AppButton(
                text: primaryButtonText!,
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onPrimaryPressed != null) onPrimaryPressed!();
                },
              ),
            if (secondaryButtonText != null) ...[
              const SizedBox(height: 8.0),
              AppButton(
                text: secondaryButtonText!,
                type: AppButtonType.outlined,
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onSecondaryPressed != null) onSecondaryPressed!();
                },
              ),
            ],
          ],
        ),
      ],
    );
  }
}
