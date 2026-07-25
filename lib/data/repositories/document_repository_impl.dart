import 'dart:convert';

import '../../core/logger/app_logger.dart';
import '../../core/services/ai/gemini_document_analyzer.dart';
import '../../core/services/document/ocr_text_extractor.dart';
import '../../core/services/storage/preferences_service.dart';
import '../../domain/entities/parsed_document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../models/parsed_document_model.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final OcrTextExtractor ocrExtractor;
  final GeminiDocumentAnalyzer analyzer;

  static const String _keyDocuments = 'pref_saved_documents_v1';

  DocumentRepositoryImpl({
    required this.ocrExtractor,
    required this.analyzer,
  });

  @override
  Future<List<ParsedDocumentEntity>> getSavedDocuments() async {
    try {
      final rawStr = PreferencesService.getString(_keyDocuments);
      if (rawStr != null && rawStr.isNotEmpty) {
        final List<dynamic> list = jsonDecode(rawStr);
        return list.map((j) => ParsedDocumentModel.fromJson(j as Map<String, dynamic>)).toList();
      }
    } catch (e, stack) {
      AppLogger.error('DocumentRepositoryImpl: Error reading saved documents', e, stack);
    }
    return [];
  }

  @override
  Future<ParsedDocumentEntity> processAndSaveDocument({
    required String filePath,
    required String fileName,
    required String fileType,
    required String fileSize,
  }) async {
    AppLogger.info('DocumentRepositoryImpl: Processing $fileName');

    // 1. OCR Text Extraction
    final ocrResult = await ocrExtractor.extractTextFromFile(
      filePath: filePath,
      fileName: fileName,
    );

    // 2. Gemini AI Analysis
    final parsedModel = await analyzer.analyzeDocumentText(
      fileName: fileName,
      rawOcrText: ocrResult.extractedText,
      fileType: fileType,
      fileSize: fileSize,
    );

    // 3. Save to local storage
    final docs = await getSavedDocuments();
    final updatedList = [parsedModel, ...docs.map((d) => ParsedDocumentModel(
      id: d.id,
      fileName: d.fileName,
      fileType: d.fileType,
      uploadDate: d.uploadDate,
      fileSize: d.fileSize,
      category: d.category,
      rawOcrText: d.rawOcrText,
      simpleSummary: d.simpleSummary,
      purpose: d.purpose,
      benefits: d.benefits,
      eligibility: d.eligibility,
      requiredDocuments: d.requiredDocuments,
      deadlines: d.deadlines,
      warnings: d.warnings,
      smartHighlights: d.smartHighlights,
      languageCode: d.languageCode,
    ))];

    await _saveToStorage(updatedList);
    return parsedModel;
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    final docs = await getSavedDocuments();
    final updatedList = docs.where((d) => d.id != documentId).map((d) => ParsedDocumentModel(
      id: d.id,
      fileName: d.fileName,
      fileType: d.fileType,
      uploadDate: d.uploadDate,
      fileSize: d.fileSize,
      category: d.category,
      rawOcrText: d.rawOcrText,
      simpleSummary: d.simpleSummary,
      purpose: d.purpose,
      benefits: d.benefits,
      eligibility: d.eligibility,
      requiredDocuments: d.requiredDocuments,
      deadlines: d.deadlines,
      warnings: d.warnings,
      smartHighlights: d.smartHighlights,
      languageCode: d.languageCode,
    )).toList();

    await _saveToStorage(updatedList);
  }

  @override
  Future<List<ParsedDocumentEntity>> searchDocuments(String query) async {
    final docs = await getSavedDocuments();
    if (query.trim().isEmpty) return docs;
    final q = query.toLowerCase();

    return docs.where((d) {
      final titleMatch = d.fileName.toLowerCase().contains(q);
      final catMatch = d.category.toLowerCase().contains(q);
      final benefitMatch = d.benefits.toLowerCase().contains(q);
      final ocrMatch = d.rawOcrText.toLowerCase().contains(q);

      return titleMatch || catMatch || benefitMatch || ocrMatch;
    }).toList();
  }

  Future<void> _saveToStorage(List<ParsedDocumentModel> list) async {
    final jsonStr = jsonEncode(list.map((d) => d.toJson()).toList());
    await PreferencesService.setString(_keyDocuments, jsonStr);
  }
}
