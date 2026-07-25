import 'package:krishisahayak/data/models/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeatherModel Tests', () {
    test('WeatherModel correctly parses JSON and formats advisory', () {
      final now = DateTime.now();
      final model = WeatherModel(
        temperature: 30.5,
        condition: 'Sunny',
        humidity: 50,
        windSpeed: 10.0,
        rainProbability: 0,
        farmingAdvice: 'Good day for harvesting.',
        locationName: 'Nashik',
        iconCode: 'sunny',
        lastUpdated: now,
      );

      final json = model.toJson();
      expect(json['temperature'], equals(30.5));
      expect(json['condition'], equals('Sunny'));

      final fromJson = WeatherModel.fromJson(json);
      expect(fromJson.temperature, equals(30.5));
      expect(fromJson.farmingAdvice, equals('Good day for harvesting.'));
    });
  });
}
