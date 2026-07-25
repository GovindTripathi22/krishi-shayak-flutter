import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/app_localizations_provider.dart';

class LanguageOption {
  final String code;
  final String englishName;
  final String nativeName;

  const LanguageOption({
    required this.code,
    required this.englishName,
    required this.nativeName,
  });
}

/// Reusable Language Selector Component for 7 Regional Languages
class LanguageSelectorWidget extends ConsumerWidget {
  const LanguageSelectorWidget({super.key});

  static const List<LanguageOption> supportedLanguages = [
    LanguageOption(code: 'en', englishName: 'English', nativeName: 'English'),
    LanguageOption(code: 'hi', englishName: 'Hindi', nativeName: 'हिन्दी'),
    LanguageOption(code: 'mr', englishName: 'Marathi', nativeName: 'मराठी'),
    LanguageOption(code: 'gu', englishName: 'Gujarati', nativeName: 'ગુજરાતી'),
    LanguageOption(code: 'ta', englishName: 'Tamil', nativeName: 'தமிழ்'),
    LanguageOption(code: 'te', englishName: 'Telugu', nativeName: 'తెలుగు'),
    LanguageOption(code: 'kn', englishName: 'Kannada', nativeName: 'ಕನ್ನಡ'),
  ];

  static void showLanguageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLarge)),
      ),
      builder: (ctx) => const LanguageSelectorWidget(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.selectLanguage,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: supportedLanguages.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final lang = supportedLanguages[index];
                final isSelected = currentLocale.languageCode == lang.code;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  tileColor: isSelected ? AppColors.primaryContainer.withOpacity(0.4) : null,
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? AppColors.primary : AppColors.surfaceVariantLight,
                    child: Text(
                      lang.code.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.onBackgroundLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  title: Text(
                    lang.nativeName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    lang.englishName,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 28.0)
                      : null,
                  onTap: () {
                    ref.read(localeProvider.notifier).setLanguageCode(lang.code);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
