import 'package:equatable/equatable.dart';

/// Base Failure class for Repository returns in Domain layer
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network connection issue. Please check internet connection.'])
      : super(message, 'NETWORK_FAILURE');
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server failure occurred. Please try again later.'])
      : super(message, 'SERVER_FAILURE');
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed. Please log in again.'])
      : super(message, 'AUTH_FAILURE');
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Local storage error occurred.'])
      : super(message, 'CACHE_FAILURE');
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Something went wrong. Please try again.'])
      : super(message, 'UNKNOWN_FAILURE');
}
