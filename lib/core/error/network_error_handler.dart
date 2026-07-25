import 'exceptions.dart';
import 'failures.dart';

/// Network Error Mapper utility
class NetworkErrorHandler {
  static Failure handleException(dynamic exception) {
    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is AuthException) {
      return AuthFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is AppException) {
      return UnknownFailure(exception.message);
    } else {
      return UnknownFailure(exception?.toString() ?? 'An unexpected error occurred.');
    }
  }

  static String getFriendlyMessage(dynamic error) {
    if (error is Failure) {
      return error.message;
    } else if (error is AppException) {
      return error.message;
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
