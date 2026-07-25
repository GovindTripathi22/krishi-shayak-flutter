import 'dart:ui';
import 'package:flutter/material.dart';

import '../logger/app_logger.dart';

/// Global Uncaught Exception Handler for KrishiSahayak
class GlobalErrorHandler {
  static void init() {
    // Capture uncaught Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      AppLogger.error('Flutter Framework Error: ${details.exceptionAsString()}', details.exception, details.stack);
    };

    // Capture uncaught Platform / Async errors
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      AppLogger.error('Platform Uncaught Async Error: $error', error, stack);
      return true;
    };
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 14.0),
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
