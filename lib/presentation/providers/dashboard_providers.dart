import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../data/models/weather_model.dart';
import '../../domain/entities/farmer_alert_entity.dart';
import '../../domain/entities/government_scheme_entity.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/government_scheme_repository.dart';
import '../../domain/repositories/recommendation_repository.dart';
// Dynamic Time-of-Day Greeting
final timeGreetingProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour;
  if (hour >= 4 && hour < 12) {
    return 'Good Morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
});

// Weather Provider
final weatherProvider = FutureProvider<WeatherEntity>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return WeatherModel.fromJson(const {
    'temperature': 29.0,
    'condition': 'Partly Sunny & Mild Wind',
    'humidity': 62,
    'windSpeed': 14.5,
    'rainProbability': 15,
    'farmingAdvice': 'Favorable conditions for foliar spray and soil moisture testing in grape & wheat crops.',
    'locationName': 'Nashik, Maharashtra',
    'iconCode': 'partly_sunny',
  });
});

// Alerts Provider
final alertsNotifierProvider = StateNotifierProvider<AlertsNotifier, List<FarmerAlertEntity>>((ref) {
  return AlertsNotifier();
});

class AlertsNotifier extends StateNotifier<List<FarmerAlertEntity>> {
  AlertsNotifier()
      : super([
          FarmerAlertEntity(
            id: 'alt_1',
            title: 'PM-KISAN 16th Installment Credited',
            message: '₹2,000 has been credited to your linked bank account. Check account summary.',
            type: AlertType.payment,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          FarmerAlertEntity(
            id: 'alt_2',
            title: 'PMFBY Kharif Insurance Deadline',
            message: 'Only 5 days left to submit crop insurance application for Kharif season.',
            type: AlertType.deadline,
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          FarmerAlertEntity(
            id: 'alt_3',
            title: 'Unseasonal Rain Advisory',
            message: 'Light to moderate rainfall expected in Nashik region over the next 48 hours.',
            type: AlertType.heavyRain,
            timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          ),
        ]);

  void dismissAlert(String alertId) {
    state = state.map((a) => a.id == alertId ? a.copyWith(isDismissed: true) : a).toList();
  }
}

// Recommended Schemes Provider
final recommendedSchemesProvider = FutureProvider<List<RecommendationEntity>>((ref) async {
  final profile = ref.watch(authControllerProvider).farmerProfile;
  if (profile == null) return [];
  return sl<RecommendationRepository>().getTopRecommendations(profile);
});

// Continue Reading Last Scheme Provider
final continueReadingProvider = StateProvider<GovernmentSchemeEntity?>((ref) => null);
