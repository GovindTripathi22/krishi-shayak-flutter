import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors/app_colors.dart' if (dart.library.io) '../../core/constants/app_colors.dart';
import '../../core/routing/app_routes.dart';
import 'language_selector_widget.dart';

/// Reusable Top App Bar Component
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showLanguageSelector;
  final bool showNotificationIcon;
  final List<Widget>? actions;

  const AppTopBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showLanguageSelector = true,
    this.showNotificationIcon = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      leading: (showBackButton && canPop)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            )
          : const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.eco, color: AppColors.primary, size: 28.0),
            ),
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions ??
          [
            if (showLanguageSelector)
              IconButton(
                icon: const Icon(Icons.translate_rounded, color: AppColors.primary),
                tooltip: 'Change Language',
                onPressed: () {
                  LanguageSelectorWidget.showLanguageModal(context);
                },
              ),
            if (showNotificationIcon)
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {
                  context.push(AppRoutes.notifications);
                },
              ),
            const SizedBox(width: 8.0),
          ],
    );
  }
}
