import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final int rainProbability;
  final String farmingAdvice;
  final String locationName;
  final String iconCode;
  final DateTime lastUpdated;

  const WeatherEntity({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.rainProbability,
    required this.farmingAdvice,
    required this.locationName,
    required this.iconCode,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        temperature,
        condition,
        humidity,
        windSpeed,
        rainProbability,
        farmingAdvice,
        locationName,
        iconCode,
        lastUpdated,
      ];
}
