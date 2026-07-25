import '../../logger/app_logger.dart';

abstract class IAnalyticsService {
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});
  Future<void> setCurrentScreen(String screenName);
}

class FirebaseAnalyticsService implements IAnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    AppLogger.info('AnalyticsService: Event logged -> $name, params: $parameters');
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    AppLogger.info('AnalyticsService: Screen changed -> $screenName');
  }
}
