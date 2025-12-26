/// Either Type Utilities for Repository Pattern
/// Uses dart_either package for functional error handling

import 'package:dart_either/dart_either.dart';
import '../errors/failures.dart';

/// Type alias for repository returns
typedef Result<T> = Either<Failure, T>;

/// Extension methods for Result type
extension ResultX<T> on Result<T> {
  /// Get value or throw on Left
  T getOrThrow() => fold(
    ifLeft: (failure) => throw Exception(failure.message),
    ifRight: (value) => value,
  );

  /// Get value or return default
  T getOrElse(T defaultValue) =>
      fold(ifLeft: (_) => defaultValue, ifRight: (value) => value);

  /// Get value or null
  T? getOrNull() => fold(ifLeft: (_) => null, ifRight: (value) => value);

  /// Check if is success
  bool get isSuccess => isRight;

  /// Check if is failure
  bool get isFailure => isLeft;

  /// Get failure or null
  Failure? get failureOrNull =>
      fold(ifLeft: (failure) => failure, ifRight: (_) => null);
}

/// Helper functions for creating Results
Result<T> success<T>(T value) => Right(value);
Result<T> failure<T>(Failure f) => Left(f);

/// Helper for async operations
Future<Result<T>> tryCatch<T>(
  Future<T> Function() fn, {
  Failure Function(Object error, StackTrace stack)? onError,
}) async {
  try {
    final result = await fn();
    return success(result);
  } catch (e, stack) {
    if (onError != null) {
      return failure(onError(e, stack));
    }
    return failure(ServerFailure(e.toString()));
  }
}

/// Helper for sync operations
Result<T> tryCatchSync<T>(
  T Function() fn, {
  Failure Function(Object error, StackTrace stack)? onError,
}) {
  try {
    final result = fn();
    return success(result);
  } catch (e, stack) {
    if (onError != null) {
      return failure(onError(e, stack));
    }
    return failure(ServerFailure(e.toString()));
  }
}
