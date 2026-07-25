import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.temperature,
    required super.condition,
    required super.humidity,
    required super.windSpeed,
    required super.rainProbability,
    required super.farmingAdvice,
    required super.locationName,
    required super.iconCode,
    required super.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 28.5,
      condition: json['condition'] as String? ?? 'Partly Cloudy',
      humidity: json['humidity'] as int? ?? 65,
      windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? 12.0,
      rainProbability: json['rainProbability'] as int? ?? 20,
      farmingAdvice: json['farmingAdvice'] as String? ??
          'Ideal conditions for fertilizer application. Maintain drip irrigation for cotton and soybean crops.',
      locationName: json['locationName'] as String? ?? 'Nashik, Maharashtra',
      iconCode: json['iconCode'] as String? ?? 'partly_cloudy',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'condition': condition,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'rainProbability': rainProbability,
      'farmingAdvice': farmingAdvice,
      'locationName': locationName,
      'iconCode': iconCode,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
