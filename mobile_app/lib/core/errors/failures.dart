/// Failure classes for domain layer error handling
/// Uses Either pattern with fpdart or dartz

abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error'])
    : super(message, code: 'SERVER');
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error'])
    : super(message, code: 'NETWORK');
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error'])
    : super(message, code: 'CACHE');
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed'])
    : super(message, code: 'AUTH');
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation failed'])
    : super(message, code: 'VALIDATION');
}
