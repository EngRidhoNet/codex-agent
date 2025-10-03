/// Lightweight Either implementation for success/failure handling.
abstract class Either<L, R> {
  /// Applies [left] or [right] callback based on value type.
  T fold<T>(T Function(L l) left, T Function(R r) right);

  /// Maps the right value with [mapper].
  Either<L, T> map<T>(T Function(R r) mapper);
}

/// Represents a left (failure) value.
class Left<L, R> extends Either<L, R> {
  /// Builds a left variant containing [value].
  const Left(this.value);

  /// Underlying value.
  final L value;

  @override
  T fold<T>(T Function(L l) left, T Function(R r) right) => left(value);

  @override
  Either<L, T> map<T>(T Function(R r) mapper) => Left<L, T>(value);
}

/// Represents a right (success) value.
class Right<L, R> extends Either<L, R> {
  /// Builds a right variant containing [value].
  const Right(this.value);

  /// Underlying value.
  final R value;

  @override
  T fold<T>(T Function(L l) left, T Function(R r) right) => right(value);

  @override
  Either<L, T> map<T>(T Function(R r) mapper) => Right<L, T>(mapper(value));
}
