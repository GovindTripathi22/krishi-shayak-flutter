import 'package:krishisahayak/data/models/parsed_document_model.dart';
import 'package:krishisahayak/domain/entities/smart_highlight_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ParsedDocumentModel Tests', () {
    test('ParsedDocumentModel correctly serializes JSON and smart highlight tags', () {
      final now = DateTime.now();
      final model = ParsedDocumentModel(
        id: 'doc_101',
        fileName: 'Drip_Scheme.pdf',
        fileType: 'pdf',
        uploadDate: now,
        fileSize: '1.4 MB',
        category: 'Subsidies',
        rawOcrText: 'Raw OCR Text',
        simpleSummary: '80% Subsidy for drip kit',
        purpose: 'Water conservation',
        benefits: '₹45,000 Subsidy',
        eligibility: const ['7/12 Land owner'],
        requiredDocuments: const ['Aadhaar'],
        deadlines: const ['31st Aug'],
        warnings: const ['Pre-sanction required'],
        smartHighlights: const [
          SmartHighlightEntity(text: '₹45,000', type: HighlightType.money),
        ],
      );

      final json = model.toJson();
      expect(json['id'], equals('doc_101'));
      expect(json['fileName'], equals('Drip_Scheme.pdf'));

      final fromJson = ParsedDocumentModel.fromJson(json);
      expect(fromJson.id, equals(model.id));
      expect(fromJson.smartHighlights.length, equals(1));
      expect(fromJson.smartHighlights.first.text, equals('₹45,000'));
    });
  });
}
