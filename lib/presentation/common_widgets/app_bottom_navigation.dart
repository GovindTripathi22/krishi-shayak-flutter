import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/routing/app_routes.dart';

/// Reusable M3 Farmer-Friendly Bottom Navigation Bar
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        if (index == currentIndex) return;
        switch (index) {
          case 0:
            context.go(AppRoutes.home);
            break;
          case 1:
            context.go(AppRoutes.schemes);
            break;
          case 2:
            context.go(AppRoutes.aiChat);
            break;
          case 3:
            context.go(AppRoutes.bookmarks);
            break;
          case 4:
            context.go(AppRoutes.profile);
            break;
        }
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: loc.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.workspace_premium_outlined),
          selectedIcon: const Icon(Icons.workspace_premium),
          label: loc.schemes,
        ),
        NavigationDestination(
          icon: const Icon(Icons.smart_toy_outlined),
          selectedIcon: const Icon(Icons.smart_toy),
          label: loc.aiChat,
        ),
        NavigationDestination(
          icon: const Icon(Icons.bookmark_border),
          selectedIcon: const Icon(Icons.bookmark),
          label: loc.bookmarks,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: loc.profile,
        ),
      ],
    );
  }
}
