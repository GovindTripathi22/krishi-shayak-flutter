import '../../logger/app_logger.dart';

abstract class IFirestoreService {
  Future<Map<String, dynamic>?> getDocument(String collection, String documentId);
  Future<List<Map<String, dynamic>>> getCollection(String collection);
  Future<void> setDocument(String collection, String documentId, Map<String, dynamic> data);
}

class FirebaseFirestoreService implements IFirestoreService {
  @override
  Future<Map<String, dynamic>?> getDocument(String collection, String documentId) async {
    AppLogger.info('FirestoreService: Getting document $collection/$documentId');
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection(String collection) async {
    AppLogger.info('FirestoreService: Fetching collection $collection');
    return [];
  }

  @override
  Future<void> setDocument(String collection, String documentId, Map<String, dynamic> data) async {
    AppLogger.info('FirestoreService: Writing document $collection/$documentId');
  }
}
