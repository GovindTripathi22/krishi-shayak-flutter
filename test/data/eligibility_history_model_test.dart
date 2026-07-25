import 'package:krishisahayak/data/models/eligibility_history_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EligibilityHistoryModel Tests', () {
    test('EligibilityHistoryModel correctly serializes to and from JSON', () {
      final now = DateTime.now();
      final model = EligibilityHistoryModel(
        id: 'hist_123',
        checkDate: now,
        state: 'Maharashtra',
        crop: 'Wheat',
        totalEligibleCount: 4,
        topSchemeNames: const ['PM-KISAN', 'PMFBY'],
      );

      final json = model.toJson();
      expect(json['id'], equals('hist_123'));
      expect(json['state'], equals('Maharashtra'));

      final fromJson = EligibilityHistoryModel.fromJson(json);
      expect(fromJson.id, equals(model.id));
      expect(fromJson.totalEligibleCount, equals(4));
    });
  });
}
