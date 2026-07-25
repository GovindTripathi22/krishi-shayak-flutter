import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../services/storage/preferences_service.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en', '')) {
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    final langCode = PreferencesService.getString(AppConstants.prefKeyLanguage);
    if (langCode != null && ['en', 'hi', 'mr', 'gu', 'ta', 'te', 'kn'].contains(langCode)) {
      state = Locale(langCode, '');
    } else {
      state = const Locale('hi', ''); // Default to Hindi for farmer ease
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await PreferencesService.setString(AppConstants.prefKeyLanguage, locale.languageCode);
  }

  Future<void> setLanguageCode(String languageCode) async {
    await setLocale(Locale(languageCode, ''));
  }
}
