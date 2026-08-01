import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../domain/entities/parsed_document_entity.dart';
import '../../domain/repositories/document_repository.dart';

final documentSearchQueryProvider = StateProvider<String>((ref) => '');

// Saved Documents List Provider
final savedDocumentsNotifierProvider =
    StateNotifierProvider<SavedDocumentsNotifier, List<ParsedDocumentEntity>>((ref) {
  final query = ref.watch(documentSearchQueryProvider);
  return SavedDocumentsNotifier(
    repository: sl<DocumentRepository>(),
    query: query,
  );
});

class SavedDocumentsNotifier extends StateNotifier<List<ParsedDocumentEntity>> {
  final DocumentRepository repository;
  final String query;

  SavedDocumentsNotifier({
    required this.repository,
    required this.query,
  }) : super([]) {
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    if (query.trim().isNotEmpty) {
      state = await repository.searchDocuments(query);
    } else {
      state = await repository.getSavedDocuments();
    }
  }

  Future<void> deleteDoc(String id) async {
    await repository.deleteDocument(id);
    await loadDocuments();
  }
}

// Document Upload & Analysis Processing State Notifier
class DocumentProcessingState {
  final bool isProcessing;
  final double progress; // 0.0 to 1.0
  final String? statusMessage;
  final ParsedDocumentEntity? currentDocument;
  final String? errorMessage;

  const DocumentProcessingState({
    this.isProcessing = false,
    this.progress = 0.0,
    this.statusMessage,
    this.currentDocument,
    this.errorMessage,
  });

  DocumentProcessingState copyWith({
    bool? isProcessing,
    double? progress,
    String? statusMessage,
    ParsedDocumentEntity? currentDocument,
    String? errorMessage,
  }) {
    return DocumentProcessingState(
      isProcessing: isProcessing ?? this.isProcessing,
      progress: progress ?? this.progress,
      statusMessage: statusMessage ?? this.statusMessage,
      currentDocument: currentDocument ?? this.currentDocument,
      errorMessage: errorMessage,
    );
  }
}

final documentProcessingNotifierProvider =
    StateNotifierProvider<DocumentProcessingNotifier, DocumentProcessingState>((ref) {
  return DocumentProcessingNotifier(repository: sl<DocumentRepository>());
});

class DocumentProcessingNotifier extends StateNotifier<DocumentProcessingState> {
  final DocumentRepository repository;

  DocumentProcessingNotifier({required this.repository}) : super(const DocumentProcessingState());

  Future<ParsedDocumentEntity?> processFile({
    required String filePath,
    required String fileName,
    required String fileType,
    required String fileSize,
  }) async {
    state = state.copyWith(isProcessing: true, progress: 0, statusMessage: 'Uploading document for secure processing...', errorMessage: null);

    try {
      final doc = await repository.processAndSaveDocument(
        filePath: filePath,
        fileName: fileName,
        fileType: fileType,
        fileSize: fileSize,
      );

      state = state.copyWith(
        isProcessing: false,
        progress: 1.0,
        statusMessage: 'Analysis complete.',
        currentDocument: doc,
      );

      return doc;
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Document processing failed. Please ensure file is readable.',
      );
      return null;
    }
  }

  void setCurrentDocument(ParsedDocumentEntity doc) {
    state = state.copyWith(currentDocument: doc);
  }
}
