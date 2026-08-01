import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';

import '../../common_widgets/app_bottom_navigation.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_top_bar.dart';
import '../../providers/auth_controller_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final profile = authState.farmerProfile;

    return Scaffold(
      appBar: AppTopBar(title: loc.profile),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 48.0,
                      backgroundColor: AppColors.primaryContainer,
                      child: Icon(Icons.person, size: 56.0, color: AppColors.primary),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      profile?.fullName ?? (authState.isGuest ? 'Guest Farmer' : 'Kisan Mitra'),
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      authState.user?.phoneNumber.isNotEmpty == true
                          ? '+91 ${authState.user!.phoneNumber}'
                          : (authState.isGuest ? 'Guest Account' : 'Phone Not Linked'),
                      style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.outlineLight),
                    ),
                    const SizedBox(height: 12.0),
                    if (profile != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          '${profile.state} • ${profile.primaryCrop}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              if (!authState.isGuest)
                AppCard(
                  child: ListTile(
                    leading: const Icon(Icons.edit_rounded, color: AppColors.primary),
                    title: Text('Edit Profile Information', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Update personal & crop details'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AppRoutes.editProfile),
                  ),
                )
              else
                AppCard(
                  backgroundColor: AppColors.accentLight.withOpacity(0.3),
                  child: ListTile(
                    leading: const Icon(Icons.star_rounded, color: AppColors.accentDark),
                    title: Text('Create Full Account', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Unlock AI PDF Explainer & Saved Schemes'),
                    trailing: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary),
                    onTap: () => context.go(AppRoutes.login),
                  ),
                ),

              AppCard(
                child: ListTile(
                  leading: const Icon(Icons.settings_rounded, color: AppColors.primary),
                  title: Text(loc.settings, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.settings),
                ),
              ),

              AppCard(
                child: ListTile(
                  leading: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary),
                  title: Text(loc.adminPanel, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.adminPanel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
