/// Use case orchestrating pronunciation evaluation.
import '../../core/errors/failure.dart';
import '../../core/utils/either.dart';
import '../entities/score_entity.dart';
import '../../data/repositories/speech_repository.dart';

/// Evaluates the pronunciation score for a vocabulary target.
class EvaluatePronunciation {
  /// Creates the use case with a [repository].
  EvaluatePronunciation(this.repository);

  /// Speech repository dependency.
  final SpeechRepository repository;

  /// Executes the evaluation.
  Future<Either<Failure, ScoreEntity>> call(String target, String transcript) {
    return repository.evaluate(target, transcript);
  }
}
