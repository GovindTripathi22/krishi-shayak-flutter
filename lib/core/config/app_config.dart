import 'env_config.dart';

/// Central Application Configuration
class AppConfig {
  final String appName;
  final String apiBaseUrl;
  final Environment environment;
  final bool enableLogging;

  const AppConfig({
    required this.appName,
    required this.apiBaseUrl,
    required this.environment,
    required this.enableLogging,
  });

  factory AppConfig.fromEnv() {
    return AppConfig(
      appName: EnvConfig.appName,
      apiBaseUrl: EnvConfig.apiBaseUrl,
      environment: EnvConfig.currentEnvironment,
      enableLogging: EnvConfig.enableLogging,
    );
  }
}
