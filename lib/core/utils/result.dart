import 'package:pasal_pro/core/errors/failures.dart';

/// Result type for operations that can fail
/// Uses sealed class pattern for exhaustive handling
sealed class Result<T> {
  const Result();
}

/// Successful result with data
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Failed result with error information
class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}

/// Extension methods for Result type
extension ResultExtensions<T> on Result<T> {
  /// Check if result is successful
  bool get isSuccess => this is Success<T>;

  /// Check if result is error
  bool get isError => this is Error<T>;

  /// Get data if success, null otherwise
  T? get dataOrNull {
    return switch (this) {
      Success(data: final data) => data,
      Error() => null,
    };
  }

  /// Get failure if error, null otherwise
  Failure? get failureOrNull {
    return switch (this) {
      Success() => null,
      Error(failure: final failure) => failure,
    };
  }

  /// Map success value to another type
  Result<R> map<R>(R Function(T) transform) {
    return switch (this) {
      Success(data: final data) => Success(transform(data)),
      Error(failure: final failure) => Error(failure),
    };
  }

  /// Handle both success and error cases
  R fold<R>({
    required R Function(T) onSuccess,
    required R Function(Failure) onError,
  }) {
    return switch (this) {
      Success(data: final data) => onSuccess(data),
      Error(failure: final failure) => onError(failure),
    };
  }
}
