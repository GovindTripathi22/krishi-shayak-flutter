import 'package:flutter/material.dart';

/// KrishiSahayak Design System Color Palette (Material Design 3)
abstract class AppColors {
  // Primary - Nature Green
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryContainer = Color(0xFFE8F5E9);
  static const Color onPrimaryContainer = Color(0xFF002204);

  // Secondary - Clean White / Soft Neutral
  static const Color secondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFF0F4F1);
  static const Color onSecondaryContainer = Color(0xFF191C19);

  // Accent - Harvest Amber
  static const Color accent = Color(0xFFFFC107);
  static const Color accentDark = Color(0xFFFFA000);
  static const Color accentLight = Color(0xFFFFECB3);

  // Status & Feedback Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);
  
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF0288D1);

  // Light Mode Backgrounds & Surfaces
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFE1E5E0);
  static const Color onBackgroundLight = Color(0xFF1A1C1A);
  static const Color onSurfaceLight = Color(0xFF1A1C1A);
  static const Color outlineLight = Color(0xFF727971);

  // Dark Mode Backgrounds & Surfaces
  static const Color backgroundDark = Color(0xFF121814);
  static const Color surfaceDark = Color(0xFF1E2620);
  static const Color surfaceVariantDark = Color(0xFF2E3830);
  static const Color onBackgroundDark = Color(0xFFE2E3DD);
  static const Color onSurfaceDark = Color(0xFFE2E3DD);
  static const Color outlineDark = Color(0xFF8C938B);

  // Card & Divider Shadows
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);
  static const Color dividerLight = Color(0xFFE0E4DF);
  static const Color dividerDark = Color(0xFF333B34);
}
