import 'package:flutter/material.dart';

import 'strings/strings_en.dart';
import 'strings/strings_hi.dart';
import 'strings/strings_mr.dart';
import 'strings/strings_gu.dart';
import 'strings/strings_ta.dart';
import 'strings/strings_te.dart';
import 'strings/strings_kn.dart';

/// AppLocalizations class managing 7 regional languages
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': StringsEn.map,
    'hi': StringsHi.map,
    'mr': StringsMr.map,
    'gu': StringsGu.map,
    'ta': StringsTa.map,
    'te': StringsTe.map,
    'kn': StringsKn.map,
  };

  String translate(String key) {
    final languageCode = locale.languageCode;
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String get appName => translate('appName');
  String get appTagline => translate('appTagline');
  String get welcomeTitle => translate('welcomeTitle');
  String get welcomeSubtitle => translate('welcomeSubtitle');
  String get onboarding1Title => translate('onboarding1Title');
  String get onboarding1Desc => translate('onboarding1Desc');
  String get onboarding2Title => translate('onboarding2Title');
  String get onboarding2Desc => translate('onboarding2Desc');
  String get onboarding3Title => translate('onboarding3Title');
  String get onboarding3Desc => translate('onboarding3Desc');
  String get getStarted => translate('getStarted');
  String get next => translate('next');
  String get skip => translate('skip');
  String get back => translate('back');
  String get loginTitle => translate('loginTitle');
  String get loginSubtitle => translate('loginSubtitle');
  String get phoneNumber => translate('phoneNumber');
  String get sendOtp => translate('sendOtp');
  String get home => translate('home');
  String get schemes => translate('schemes');
  String get aiChat => translate('aiChat');
  String get eligibilityChecker => translate('eligibilityChecker');
  String get pdfExplainer => translate('pdfExplainer');
  String get bookmarks => translate('bookmarks');
  String get notifications => translate('notifications');
  String get profile => translate('profile');
  String get settings => translate('settings');
  String get adminPanel => translate('adminPanel');
  String get language => translate('language');
  String get selectLanguage => translate('selectLanguage');
  String get searchPlaceholder => translate('searchPlaceholder');
  String get retry => translate('retry');
  String get errorOccurred => translate('errorOccurred');
  String get noDataFound => translate('noDataFound');
  String get themeMode => translate('themeMode');
  String get lightTheme => translate('lightTheme');
  String get darkTheme => translate('darkTheme');
  String get systemDefault => translate('systemDefault');
}
