import '../../core/services/backend/api_client.dart';
import '../../domain/entities/parsed_document_entity.dart';
import '../../domain/entities/smart_highlight_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../models/parsed_document_model.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final ApiClient _apiClient;
  DocumentRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  ParsedDocumentEntity _fromApi(Map<String, dynamic> json) {
    final points = (json['importantPoints'] as List<dynamic>? ?? []).map((item) => item.toString()).toList();
    final deadlines = (json['deadlines'] as List<dynamic>? ?? []).map((item) => item.toString()).toList();
    return ParsedDocumentModel(id: json['id'].toString(), fileName: json['fileName']?.toString() ?? '', fileType: json['fileType']?.toString() ?? 'pdf', uploadDate: DateTime.parse(json['uploadDate'].toString()), fileSize: '${json['fileSizeBytes'] ?? 0} bytes', category: 'Document Analysis', rawOcrText: json['extractedTextPreview']?.toString() ?? '', simpleSummary: json['summary']?.toString() ?? '', purpose: points.isEmpty ? '' : points.first, benefits: points.join('\n'), eligibility: (json['eligibilityInformation'] as List<dynamic>? ?? []).map((item) => item.toString()).toList(), requiredDocuments: (json['requiredDocuments'] as List<dynamic>? ?? []).map((item) => item.toString()).toList(), deadlines: deadlines, warnings: (json['warnings'] as List<dynamic>? ?? []).map((item) => item.toString()).toList(), smartHighlights: [for (final deadline in deadlines) SmartHighlightEntity(text: deadline, type: HighlightType.deadline)], languageCode: json['language']?.toString() ?? 'en');
  }
  List<ParsedDocumentEntity> _list(dynamic response) => ((response as Map<String, dynamic>)['data'] as List<dynamic>? ?? []).map((item) => _fromApi(Map<String, dynamic>.from(item as Map))).toList();
  @override
  Future<List<ParsedDocumentEntity>> getSavedDocuments() async => _list(await _apiClient.get('/pdf/history'));
  @override
  Future<ParsedDocumentEntity> processAndSaveDocument({required String filePath, required String fileName, required String fileType, required String fileSize}) async { final response = await _apiClient.uploadFile('/pdf/upload', filePath: filePath); return _fromApi(Map<String, dynamic>.from((response as Map<String, dynamic>)['data'] as Map)); }
  @override
  Future<void> deleteDocument(String documentId) async { await _apiClient.delete('/pdf/$documentId'); }
  @override
  Future<List<ParsedDocumentEntity>> searchDocuments(String query) async => _list(await _apiClient.get('/pdf/history?q=${Uri.encodeQueryComponent(query)}'));
}
