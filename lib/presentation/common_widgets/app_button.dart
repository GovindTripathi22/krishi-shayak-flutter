import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

enum AppButtonType { primary, secondary, outlined }

/// Reusable Farmer-Friendly Button Component with Large Touch Targets
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonChild = isLoading
        ? SizedBox(
            height: 22.0,
            width: 22.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: type == AppButtonType.primary ? Colors.white : AppColors.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20.0),
                const SizedBox(width: 8.0),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );

    Widget btn;
    switch (type) {
      case AppButtonType.secondary:
        btn = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondaryContainer,
            foregroundColor: theme.colorScheme.onSecondaryContainer,
            minimumSize: Size(isFullWidth ? double.infinity : 120.0, AppConstants.minTouchTargetSize + 8.0),
          ),
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        );
        break;
      case AppButtonType.outlined:
        btn = OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: Size(isFullWidth ? double.infinity : 120.0, AppConstants.minTouchTargetSize + 8.0),
          ),
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        );
        break;
      case AppButtonType.primary:
      default:
        btn = ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(isFullWidth ? double.infinity : 120.0, AppConstants.minTouchTargetSize + 8.0),
          ),
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        );
        break;
    }

    return btn;
  }
}
