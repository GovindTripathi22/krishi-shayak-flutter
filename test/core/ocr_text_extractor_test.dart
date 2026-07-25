import 'package:krishisahayak/core/services/document/ocr_text_extractor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OcrTextExtractor Tests', () {
    test('extractTextFromFile returns OCR extracted text and page count', () async {
      final extractor = OcrTextExtractor();
      final result = await extractor.extractTextFromFile(
        filePath: '/test/path/circular.pdf',
        fileName: 'circular.pdf',
      );

      expect(result.extractedText, isNotEmpty);
      expect(result.extractedText, contains('DEPARTMENT OF AGRICULTURE'));
      expect(result.pageCount, equals(2));
      expect(result.isHighConfidence, isTrue);
    });
  });
}
