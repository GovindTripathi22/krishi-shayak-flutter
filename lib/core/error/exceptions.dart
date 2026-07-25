/// Base Exception class for AgriSathi AI
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

class NetworkException extends AppException {
  const NetworkException([String message = 'No Internet connection available.', String? code])
      : super(message, code ?? 'NETWORK_ERROR');
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException([String message = 'Server error occurred.', String? code, this.statusCode])
      : super(message, code ?? 'SERVER_ERROR');
}

class AuthException extends AppException {
  const AuthException([String message = 'Authentication failed.', String? code])
      : super(message, code ?? 'AUTH_ERROR');
}

class CacheException extends AppException {
  const CacheException([String message = 'Cache operation failed.', String? code])
      : super(message, code ?? 'CACHE_ERROR');
}

class UnknownException extends AppException {
  const UnknownException([String message = 'An unexpected error occurred.', String? code])
      : super(message, code ?? 'UNKNOWN_ERROR');
}
