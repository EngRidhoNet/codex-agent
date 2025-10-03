/// Defines application-level failures for safe error propagation.
class Failure {
  /// Creates a failure with [message] and optional [cause].
  const Failure(this.message, {this.cause});

  /// Human readable message.
  final String message;

  /// Optional underlying error.
  final Object? cause;

  @override
  String toString() => 'Failure(message: ' + message + ', cause: ' + cause.toString() + ')';
}
