import 'package:flutter/foundation.dart';

/// Base class for all domain & data failures
@immutable
abstract class Failure {
  final String message;
  final String? code;
  final Exception? originalException;

  const Failure({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network connectivity issue encountered.',
    super.code = 'NETWORK_ERROR',
    super.originalException,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code = 'SERVER_ERROR',
    super.originalException,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.originalException,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to load local cached data.',
    super.code = 'CACHE_ERROR',
    super.originalException,
  });
}

/// Functional Result Monad representing either a Success with [data] or a [Failure]
@immutable
abstract class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  T? get dataOrNull => isSuccess ? (this as Success<T>).data : null;
  Failure? get failureOrNull => isFailure ? (this as FailureResult<T>).failure : null;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onFailure((this as FailureResult<T>).failure);
    }
  }

  factory Result.success(T data) = Success<T>;
  factory Result.failure(Failure failure) = FailureResult<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);
}
