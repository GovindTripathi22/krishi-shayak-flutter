import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/env_config.dart';
import 'core/di/injection_container.dart';
import 'core/error/global_error_handler.dart';
import 'core/logger/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Global Error Handler
  GlobalErrorHandler.init();

  // Initialize Environment Config
  await EnvConfig.init();

  // Initialize Dependency Injection & Services
  await initDependencyInjection();

  AppLogger.info('AgriSathi AI Phase 1 initialized successfully.');

  runApp(
    const ProviderScope(
      child: AgriSathiApp(),
    ),
  );
}
