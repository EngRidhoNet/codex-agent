/// Use case writing session activity to persistent storage.
import '../../core/errors/failure.dart';
import '../../core/utils/either.dart';
import '../entities/session_entity.dart';
import '../../data/repositories/session_repository.dart';

/// Logs the session and returns the stored entity.
class LogSessionEvent {
  /// Creates use case with [repository].
  LogSessionEvent(this.repository);

  /// Session repository dependency.
  final SessionRepository repository;

  /// Executes the logging process.
  Future<Either<Failure, SessionEntity>> call(SessionEntity session) {
    return repository.logSession(session);
  }
}
