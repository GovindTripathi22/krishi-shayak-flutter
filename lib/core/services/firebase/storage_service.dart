import '../../logger/app_logger.dart';

abstract class IStorageService {
  Future<String?> uploadFile(String path, List<int> bytes);
  Future<void> deleteFile(String path);
}

class FirebaseStorageService implements IStorageService {
  @override
  Future<String?> uploadFile(String path, List<int> bytes) async {
    AppLogger.info('StorageService: Uploading file to $path (${bytes.length} bytes)');
    return 'https://storage.agrisathi.ai/$path';
  }

  @override
  Future<void> deleteFile(String path) async {
    AppLogger.info('StorageService: Deleting file at $path');
  }
}
