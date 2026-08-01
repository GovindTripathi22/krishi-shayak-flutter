import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../logger/app_logger.dart';

const _kLanguageKey = 'preferred_language';

/// All 7 supported languages with metadata
const List<Map<String, String>> kSupportedLanguages = [
  {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇬🇧'},
  {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी', 'flag': '🇮🇳'},
  {'code': 'mr', 'name': 'Marathi', 'nativeName': 'मराठी', 'flag': '🇮🇳'},
  {'code': 'gu', 'name': 'Gujarati', 'nativeName': 'ગુજરાતી', 'flag': '🇮🇳'},
  {'code': 'ta', 'name': 'Tamil', 'nativeName': 'தமிழ்', 'flag': '🇮🇳'},
  {'code': 'te', 'name': 'Telugu', 'nativeName': 'తెలుగు', 'flag': '🇮🇳'},
  {'code': 'kn', 'name': 'Kannada', 'nativeName': 'ಕನ್ನಡ', 'flag': '🇮🇳'},
];

/// Language State
class LanguageState {
  final String languageCode;
  final bool isLoading;

  const LanguageState({
    this.languageCode = 'en',
    this.isLoading = false,
  });

  LanguageState copyWith({String? languageCode, bool? isLoading}) =>
      LanguageState(
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
      );
}

final languageServiceProvider =
    StateNotifierProvider<LanguageService, LanguageState>((ref) => LanguageService());

/// Production Language Service — Persists selected language across app restarts
class LanguageService extends StateNotifier<LanguageState> {
  LanguageService() : super(const LanguageState()) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      state = state.copyWith(isLoading: true);
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_kLanguageKey) ?? 'en';
      state = state.copyWith(languageCode: saved, isLoading: false);
      AppLogger.info('LanguageService: Loaded saved language: $saved');
    } catch (e, stack) {
      AppLogger.error('LanguageService: Failed to load saved language', e, stack);
      state = state.copyWith(isLoading: false);
    }
  }

  /// Switch language and persist to SharedPreferences
  Future<void> setLanguage(String langCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLanguageKey, langCode);
      state = state.copyWith(languageCode: langCode);
      AppLogger.info('LanguageService: Language changed to $langCode');
    } catch (e, stack) {
      AppLogger.error('LanguageService: Failed to save language', e, stack);
    }
  }

  String get currentLanguage => state.languageCode;

  Map<String, String>? get currentLanguageInfo =>
      kSupportedLanguages.firstWhere(
        (l) => l['code'] == state.languageCode,
        orElse: () => kSupportedLanguages.first,
      );
}
