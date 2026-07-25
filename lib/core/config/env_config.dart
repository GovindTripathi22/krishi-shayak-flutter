import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, staging, production }

/// Environment Variables & Configuration Loader
class EnvConfig {
  static Environment _environment = Environment.development;

  static Future<void> init({Environment environment = Environment.development}) async {
    _environment = environment;
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // Fallback defaults if dotenv file is missing
    }
  }

  static Environment get currentEnvironment => _environment;

  static String get appName => dotenv.get('APP_NAME', fallback: 'AgriSathi AI');
  static String get apiBaseUrl => dotenv.get('API_BASE_URL', fallback: 'https://api.agrisathi.ai/v1');
  static String get aiModelEndpoint => dotenv.get('AI_MODEL_ENDPOINT', fallback: 'https://ai.agrisathi.ai/v1/chat');
  static String get apiKey => dotenv.get('API_KEY', fallback: 'dev_key_agrisathi_2026');
  static bool get enableLogging => dotenv.get('ENABLE_LOGGING', fallback: 'true').toLowerCase() == 'true';
  static bool get enableAnalytics => dotenv.get('ENABLE_ANALYTICS', fallback: 'false').toLowerCase() == 'true';
  static String get firebaseProjectId => dotenv.get('FIREBASE_PROJECT_ID', fallback: 'agrisathi-ai-dev');
}
