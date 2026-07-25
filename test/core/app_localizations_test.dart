import 'package:agrisathi_ai/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalizations Tests', () {
    test('English translations match expected keys', () {
      final loc = AppLocalizations(const Locale('en', ''));
      expect(loc.appName, equals('AgriSathi AI'));
      expect(loc.getStarted, equals('Get Started'));
      expect(loc.home, equals('Home'));
    });

    test('Hindi translations match expected keys', () {
      final loc = AppLocalizations(const Locale('hi', ''));
      expect(loc.appName, equals('एग्रीसाथी एआई'));
      expect(loc.getStarted, equals('शुरू करें'));
      expect(loc.home, equals('होम'));
    });

    test('Marathi translations match expected keys', () {
      final loc = AppLocalizations(const Locale('mr', ''));
      expect(loc.appName, equals('ॲग्रीसाथी एआय'));
      expect(loc.getStarted, equals('सुरू करा'));
    });

    test('Gujarati translations match expected keys', () {
      final loc = AppLocalizations(const Locale('gu', ''));
      expect(loc.appName, equals('એગ્રીસાથી એઆઈ'));
    });

    test('Tamil translations match expected keys', () {
      final loc = AppLocalizations(const Locale('ta', ''));
      expect(loc.appName, equals('அக்ரிசாதி AI'));
    });

    test('Telugu translations match expected keys', () {
      final loc = AppLocalizations(const Locale('te', ''));
      expect(loc.appName, equals('అగ్రిసాథి AI'));
    });

    test('Kannada translations match expected keys', () {
      final loc = AppLocalizations(const Locale('kn', ''));
      expect(loc.appName, equals('ಅಗ್ರಿಸಾಥಿ AI'));
    });
  });
}
