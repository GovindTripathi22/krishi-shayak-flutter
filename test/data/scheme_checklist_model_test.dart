import 'package:krishisahayak/data/models/checklist_item_model.dart';
import 'package:krishisahayak/data/models/scheme_checklist_model.dart';
import 'package:krishisahayak/domain/entities/checklist_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SchemeChecklistModel Tests', () {
    test('SchemeChecklistModel calculates completion percentage correctly', () {
      final now = DateTime.now();
      final model = SchemeChecklistModel(
        schemeId: 'sch_1',
        schemeName: 'Kisan Credit Card',
        items: const [
          ChecklistItemModel(
            id: 'i1',
            documentName: 'Aadhaar Card',
            purposeExplanation: 'Identity',
            status: DocumentStatus.completed,
          ),
          ChecklistItemModel(
            id: 'i2',
            documentName: 'Land Record',
            purposeExplanation: 'Ownership',
            status: DocumentStatus.pending,
          ),
        ],
        lastUpdated: now,
      );

      expect(model.completionPercentage, equals(50.0));
      expect(model.completedCount, equals(1));
      expect(model.pendingCount, equals(1));

      final json = model.toJson();
      expect(json['schemeId'], equals('sch_1'));

      final fromJson = SchemeChecklistModel.fromJson(json);
      expect(fromJson.completionPercentage, equals(50.0));
    });
  });
}
