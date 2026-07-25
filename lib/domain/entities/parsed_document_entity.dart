import 'package:equatable/equatable.dart';
import 'smart_highlight_entity.dart';

class ParsedDocumentEntity extends Equatable {
  final String id;
  final String fileName;
  final String fileType; // pdf, image
  final DateTime uploadDate;
  final String fileSize;
  final String category;
  final String rawOcrText;
  final String simpleSummary;
  final String purpose;
  final String benefits;
  final List<String> eligibility;
  final List<String> requiredDocuments;
  final List<String> deadlines;
  final List<String> warnings;
  final List<SmartHighlightEntity> smartHighlights;
  final String languageCode;

  const ParsedDocumentEntity({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.uploadDate,
    required this.fileSize,
    required this.category,
    required this.rawOcrText,
    required this.simpleSummary,
    required this.purpose,
    required this.benefits,
    required this.eligibility,
    required this.requiredDocuments,
    required this.deadlines,
    required this.warnings,
    required this.smartHighlights,
    this.languageCode = 'en',
  });

  @override
  List<Object?> get props => [
        id,
        fileName,
        fileType,
        uploadDate,
        fileSize,
        category,
        rawOcrText,
        simpleSummary,
        purpose,
        benefits,
        eligibility,
        requiredDocuments,
        deadlines,
        warnings,
        smartHighlights,
        languageCode,
      ];
}
