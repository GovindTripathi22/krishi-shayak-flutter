import 'package:flutter/material.dart';

/// Global Application Constants
abstract class AppConstants {
  static const String appName = 'AgriSathi AI';
  static const String appTagline = 'Your AI Agricultural Assistant';
  static const String appVersion = '1.0.0';

  // Spacing & Layout
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Touch Target & Corner Radii
  static const double minTouchTargetSize = 48.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 14.0;
  static const double radiusLarge = 20.0;
  static const double radiusCircular = 100.0;

  // Elevation & Shadows
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 350);
  static const Duration durationSlow = Duration(milliseconds: 600);
  static const Duration splashDelay = Duration(seconds: 2);

  // Storage Keys
  static const String prefKeyLanguage = 'pref_selected_language';
  static const String prefKeyThemeMode = 'pref_theme_mode';
  static const String prefKeyOnboardingCompleted = 'pref_onboarding_completed';
  static const String prefKeyAuthToken = 'pref_auth_token';

  // Supported Locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('hi', ''), // Hindi
    Locale('mr', ''), // Marathi
    Locale('gu', ''), // Gujarati
    Locale('ta', ''), // Tamil
    Locale('te', ''), // Telugu
    Locale('kn', ''), // Kannada
  ];
}
