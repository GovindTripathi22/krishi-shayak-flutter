import '../../logger/app_logger.dart';

abstract class ICrashlyticsService {
  Future<void> recordError(dynamic exception, StackTrace? stack, {String? reason});
  Future<void> log(String message);
}

class FirebaseCrashlyticsService implements ICrashlyticsService {
  @override
  Future<void> recordError(dynamic exception, StackTrace? stack, {String? reason}) async {
    AppLogger.error('Crashlytics logged exception: $reason', exception, stack);
  }

  @override
  Future<void> log(String message) async {
    AppLogger.info('Crashlytics breadcrumb: $message');
  }
}
