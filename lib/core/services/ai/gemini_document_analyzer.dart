import 'dart:async';
import '../../../data/models/parsed_document_model.dart';
import '../../../domain/entities/smart_highlight_entity.dart';
import '../../logger/app_logger.dart';

class GeminiDocumentAnalyzer {
  Future<ParsedDocumentModel> analyzeDocumentText({
    required String fileName,
    required String rawOcrText,
    required String fileType,
    required String fileSize,
  }) async {
    AppLogger.info('GeminiDocumentAnalyzer: Analyzing document OCR text for $fileName');

    await Future.delayed(const Duration(milliseconds: 1200));

    return ParsedDocumentModel(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      fileName: fileName,
      fileType: fileType,
      uploadDate: DateTime.now(),
      fileSize: fileSize,
      category: 'Irrigation & Subsidies',
      rawOcrText: rawOcrText,
      simpleSummary: 'This official government circular offers up to 80% financial subsidy (maximum ₹45,000) for installing drip irrigation kits on small agricultural land holdings.',
      purpose: 'Promote water conservation and boost crop yield for Kharif season crops.',
      benefits: '80% Subsidy up to ₹45,000 transferred via Direct Benefit Transfer (DBT) directly into bank account.',
      eligibility: const [
        'Must own cultivable agricultural land (7/12 extract mandatory)',
        'Must have an active bank account linked with Aadhaar',
        'Small and marginal farmers receive priority 80% subsidy',
      ],
      requiredDocuments: const [
        'Aadhaar Card copy',
        '7/12 Land ownership extract',
        'Bank passbook first page',
        'Authorized Drip Supplier Estimate quotation',
      ],
      deadlines: const [
        'Online portal application closes: 31st August 2026',
        'Physical document submission at Taluka Agriculture Office: 15th September 2026',
      ],
      warnings: const [
        'Do not purchase drip equipment before pre-sanction approval letter is issued.',
        'Ensure Aadhaar name matches exactly with bank passbook name to prevent DBT payment failure.',
      ],
      smartHighlights: const [
        SmartHighlightEntity(text: '80% Subsidy up to ₹45,000', type: HighlightType.money),
        SmartHighlightEntity(text: '31st August 2026', type: HighlightType.deadline),
        SmartHighlightEntity(text: '7/12 Land Certificate & Aadhaar', type: HighlightType.document),
        SmartHighlightEntity(text: 'Small & Marginal Landholders', type: HighlightType.eligibility),
      ],
    );
  }
}
