/// Failure classes for domain layer error handling
/// Uses Either pattern with fpdart or dartz
library;

abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error'])
    : super(code: 'SERVER');
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error'])
    : super(code: 'NETWORK');
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error'])
    : super(code: 'CACHE');
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed'])
    : super(code: 'AUTH');
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed'])
    : super(code: 'VALIDATION');
}
