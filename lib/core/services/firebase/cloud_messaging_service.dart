import '../../logger/app_logger.dart';

abstract class ICloudMessagingService {
  Future<void> initialize();
  Future<String?> getToken();
}

class FirebaseCloudMessagingService implements ICloudMessagingService {
  @override
  Future<void> initialize() async {
    AppLogger.info('CloudMessagingService: Initialized notification listeners');
  }

  @override
  Future<String?> getToken() async {
    return 'mock_fcm_token_agrisathi_2026';
  }
}
