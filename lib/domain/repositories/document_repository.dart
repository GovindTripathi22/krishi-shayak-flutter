import '../entities/parsed_document_entity.dart';

abstract class DocumentRepository {
  Future<List<ParsedDocumentEntity>> getSavedDocuments();
  Future<ParsedDocumentEntity> processAndSaveDocument({
    required String filePath,
    required String fileName,
    required String fileType,
    required String fileSize,
  });
  Future<void> deleteDocument(String documentId);
  Future<List<ParsedDocumentEntity>> searchDocuments(String query);
}
