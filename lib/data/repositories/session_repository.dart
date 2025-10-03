/// Repository managing session persistence and retrieval.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/failure.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/session_entity.dart';
import '../datasources/local/isar_provider.dart';
import '../models/session_log.dart';

/// Contract for logging sessions.
abstract class SessionRepository {
  /// Persists a new log entry.
  Future<Either<Failure, SessionEntity>> logSession(SessionEntity session);

  /// Returns all stored sessions.
  Future<Either<Failure, List<SessionEntity>>> getSessions();

  /// Exports sessions as JSON serialisable maps.
  Future<Either<Failure, List<Map<String, dynamic>>>> exportSessions();
}

class _SessionRepositoryImpl implements SessionRepository {
  _SessionRepositoryImpl(this._sessionBoxFuture);

  final Future<Box<Map>> Function() _sessionBoxFuture;
  final _uuid = const Uuid();

  @override
  Future<Either<Failure, SessionEntity>> logSession(SessionEntity session) async {
    try {
      final box = await _sessionBoxFuture();
      final id = session.id.isEmpty ? _uuid.v4() : session.id;
      final model = SessionLogModel(
        id: id,
        date: session.date,
        feature: session.feature,
        durationSec: session.durationSec,
        notes: session.notes,
      );
      await box.put(id, model.toMap());
      return Right(model.toEntity());
    } catch (error) {
      return Left(Failure('Unable to log session', cause: error));
    }
  }

  @override
  Future<Either<Failure, List<SessionEntity>>> getSessions() async {
    try {
      final box = await _sessionBoxFuture();
      final sessions = box.values.map(SessionLogModel.fromMap).map((model) => model.toEntity()).toList();
      sessions.sort((a, b) => b.date.compareTo(a.date));
      return Right(sessions);
    } catch (error) {
      return Left(Failure('Unable to load sessions', cause: error));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> exportSessions() async {
    final sessions = await getSessions();
    return sessions.map((values) => values
        .map((session) => SessionLogModel(
              id: session.id,
              date: session.date,
              feature: session.feature,
              durationSec: session.durationSec,
              notes: session.notes,
            ).toMap())
        .toList());
  }
}

/// Provides a [SessionRepository] bound to Hive storage.
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return _SessionRepositoryImpl(() async {
    final asyncBox = ref.read(sessionBoxProvider.future);
    return asyncBox;
  });
});
