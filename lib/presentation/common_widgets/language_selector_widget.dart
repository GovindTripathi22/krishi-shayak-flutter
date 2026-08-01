import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/app_localizations_provider.dart';
import '../../core/services/voice/voice_service.dart';

class LanguageOption {
  final String code;
  final String englishName;
  final String nativeName;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.englishName,
    required this.nativeName,
    this.flag = '🇮🇳',
  });
}

/// Reusable Language Selector Widget — 7 Regional Languages, Fully Persisted
class LanguageSelectorWidget extends ConsumerWidget {
  const LanguageSelectorWidget({super.key});

  static const List<LanguageOption> supportedLanguages = [
    LanguageOption(code: 'en', englishName: 'English', nativeName: 'English', flag: '🇬🇧'),
    LanguageOption(code: 'hi', englishName: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    LanguageOption(code: 'mr', englishName: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳'),
    LanguageOption(code: 'gu', englishName: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳'),
    LanguageOption(code: 'ta', englishName: 'Tamil', nativeName: 'தமிழ்', flag: '🇮🇳'),
    LanguageOption(code: 'te', englishName: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳'),
    LanguageOption(code: 'kn', englishName: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳'),
  ];

  static void showLanguageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLarge)),
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
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Language persists after restart. AI responses will be translated.',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: supportedLanguages.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final lang = supportedLanguages[index];
                final isSelected = currentLocale.languageCode == lang.code;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  tileColor: isSelected
                      ? AppColors.primaryContainer.withOpacity(0.4)
                      : null,
                  leading: CircleAvatar(
                    backgroundColor:
                        isSelected ? AppColors.primary : AppColors.surfaceVariantLight,
                    child: Text(
                      lang.flag,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  title: Text(
                    lang.nativeName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    lang.englishName,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.outlineLight),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 28.0)
                      : null,
                  onTap: () async {
                    // Update locale (UI strings)
                    await ref
                        .read(localeProvider.notifier)
                        .setLanguageCode(lang.code);

                    // Update TTS language for voice service
                    ref
                        .read(voiceServiceProvider.notifier)
                        .updateLanguage(lang.code);

                    if (context.mounted) Navigator.of(context).pop();
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
