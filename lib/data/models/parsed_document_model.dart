import '../../domain/entities/parsed_document_entity.dart';
import '../../domain/entities/smart_highlight_entity.dart';

class ParsedDocumentModel extends ParsedDocumentEntity {
  const ParsedDocumentModel({
    required super.id,
    required super.fileName,
    required super.fileType,
    required super.uploadDate,
    required super.fileSize,
    required super.category,
    required super.rawOcrText,
    required super.simpleSummary,
    required super.purpose,
    required super.benefits,
    required super.eligibility,
    required super.requiredDocuments,
    required super.deadlines,
    required super.warnings,
    required super.smartHighlights,
    super.languageCode,
  });

  factory ParsedDocumentModel.fromJson(Map<String, dynamic> json) {
    return ParsedDocumentModel(
      id: json['id'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      fileType: json['fileType'] as String? ?? 'pdf',
      uploadDate: json['uploadDate'] != null
          ? DateTime.parse(json['uploadDate'] as String)
          : DateTime.now(),
      fileSize: json['fileSize'] as String? ?? '1.2 MB',
      category: json['category'] as String? ?? 'Government Circular',
      rawOcrText: json['rawOcrText'] as String? ?? '',
      simpleSummary: json['simpleSummary'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
      benefits: json['benefits'] as String? ?? '',
      eligibility: (json['eligibility'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      deadlines: (json['deadlines'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      smartHighlights: (json['smartHighlights'] as List<dynamic>?)
              ?.map((h) => SmartHighlightEntity(
                    text: h['text'] as String? ?? '',
                    type: HighlightType.values.firstWhere(
                      (t) => t.name == (h['type'] as String? ?? 'money'),
                      orElse: () => HighlightType.money,
                    ),
                  ))
              .toList() ??
          [],
      languageCode: json['languageCode'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileType': fileType,
      'uploadDate': uploadDate.toIso8601String(),
      'fileSize': fileSize,
      'category': category,
      'rawOcrText': rawOcrText,
      'simpleSummary': simpleSummary,
      'purpose': purpose,
      'benefits': benefits,
      'eligibility': eligibility,
      'requiredDocuments': requiredDocuments,
      'deadlines': deadlines,
      'warnings': warnings,
      'smartHighlights': smartHighlights
          .map((h) => {
                'text': h.text,
                'type': h.type.name,
              })
          .toList(),
      'languageCode': languageCode,
    };
  }
}
