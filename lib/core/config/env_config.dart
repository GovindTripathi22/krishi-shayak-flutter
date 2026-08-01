enum Environment { development, staging, production }

/// Environment Variables & Configuration Loader — Production Safe
class EnvConfig {
  static Environment _environment = Environment.development;

  static Future<void> init({Environment environment = Environment.development}) async {
    _environment = environment;
  }

  static Environment get currentEnvironment => _environment;

  static String get appName => 'KrishiSahayak';
  static String get apiBaseUrl => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:5004/api/v1',
      );
  static String get aiModelEndpoint => '$apiBaseUrl/chat';
  static bool get enableLogging => _environment != Environment.production;
  static bool get enableAnalytics => _environment == Environment.production;
  static String get firebaseProjectId => 'krishisahayak-ai';
}
