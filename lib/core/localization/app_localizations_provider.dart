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

  static const List<String> _supported = ['en', 'hi', 'mr', 'gu', 'ta', 'te', 'kn'];

  Future<void> _loadSavedLocale() async {
    final langCode = PreferencesService.getString(AppConstants.prefKeyLanguage);
    if (langCode != null && _supported.contains(langCode)) {
      state = Locale(langCode, '');
    } else {
      state = const Locale('en', '');
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await PreferencesService.setString(
        AppConstants.prefKeyLanguage, locale.languageCode);
  }

  Future<void> setLanguageCode(String languageCode) async {
    if (!_supported.contains(languageCode)) return;
    await setLocale(Locale(languageCode, ''));
  }

  String get currentCode => state.languageCode;
}
