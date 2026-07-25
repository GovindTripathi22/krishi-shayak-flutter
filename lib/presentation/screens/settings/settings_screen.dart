import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_provider.dart';

import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_dialog.dart';
import '../../common_widgets/app_top_bar.dart';
import '../../common_widgets/language_selector_widget.dart';
import '../auth_controller_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppTopBar(title: loc.settings),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            // Language Selection
            AppCard(
              child: ListTile(
                leading: const Icon(Icons.language_rounded, color: AppColors.primary),
                title: Text(loc.language, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text('Current: ${loc.selectLanguage}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => LanguageSelectorWidget.showLanguageModal(context),
              ),
            ),

            // Theme Mode
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      loc.themeMode,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(loc.lightTheme),
                    value: ThemeMode.light,
                    groupValue: themeMode,
                    onChanged: (val) => ref.read(themeModeProvider.notifier).setThemeMode(val!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(loc.darkTheme),
                    value: ThemeMode.dark,
                    groupValue: themeMode,
                    onChanged: (val) => ref.read(themeModeProvider.notifier).setThemeMode(val!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(loc.systemDefault),
                    value: ThemeMode.system,
                    groupValue: themeMode,
                    onChanged: (val) => ref.read(themeModeProvider.notifier).setThemeMode(val!),
                  ),
                ],
              ),
            ),

            // Legal & Info
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                    title: const Text('Terms & Conditions'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Logout & Account Deletion Actions
            if (authState.isAuthenticated) ...[
              const SizedBox(height: 16.0),
              AppCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.logout_rounded, color: Colors.orange),
                      title: const Text('Logout Session', style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        AppDialog.show(
                          context: context,
                          title: 'Logout',
                          message: 'Are you sure you want to log out of KrishiSahayak?',
                          primaryButtonText: 'Logout',
                          onPrimaryPressed: () async {
                            await ref.read(authControllerProvider.notifier).logout();
                            if (context.mounted) {
                              context.go(AppRoutes.login);
                            }
                          },
                          secondaryButtonText: 'Cancel',
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                      title: const Text('Delete Account', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                      onTap: () {
                        AppDialog.show(
                          context: context,
                          title: 'Delete Account',
                          message: 'Warning: Deleting your account will permanently wipe your profile and saved scheme bookmarks.',
                          primaryButtonText: 'Delete Permanently',
                          onPrimaryPressed: () async {
                            await ref.read(authControllerProvider.notifier).deleteAccount();
                            if (context.mounted) {
                              context.go(AppRoutes.login);
                            }
                          },
                          secondaryButtonText: 'Cancel',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24.0),
            Center(
              child: Text(
                'KrishiSahayak v${AppConstants.appVersion}\nCrafted with ♥ for Indian Farmers',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
