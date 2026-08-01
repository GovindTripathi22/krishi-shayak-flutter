import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Reusable Farmer-Friendly Card Component with Soft Rounded Corners & Subtle Shadows
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderSide? border;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardContent = Padding(
      padding: padding ?? const EdgeInsets.all(AppConstants.paddingMedium),
      child: child,
    );

    return Card(
      margin: margin,
      elevation: elevation ?? AppConstants.elevationLow,
      color: backgroundColor ?? theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        side: border ?? BorderSide.none,
      ),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              child: cardContent,
            )
          : cardContent,
    );
  }
}
