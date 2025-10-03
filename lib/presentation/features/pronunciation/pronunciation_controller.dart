/// Controller coordinating pronunciation practice flows.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/speech_repository.dart';
import '../../../domain/entities/score_entity.dart';

/// Holds pronunciation screen state.
class PronunciationState {
  /// Creates state for the pronunciation feature.
  const PronunciationState({
    this.score,
    this.isEvaluating = false,
    this.feedbackMessage = '',
  });

  /// Latest score entity.
  final ScoreEntity? score;

  /// Whether evaluation is running.
  final bool isEvaluating;

  /// Feedback message for the learner.
  final String feedbackMessage;

  /// Creates a copy with changes.
  PronunciationState copyWith({
    ScoreEntity? score,
    bool? isEvaluating,
    String? feedbackMessage,
  }) {
    return PronunciationState(
      score: score ?? this.score,
      isEvaluating: isEvaluating ?? this.isEvaluating,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
    );
  }
}

/// State notifier implementing evaluation logic.
class PronunciationController extends StateNotifier<PronunciationState> {
  /// Builds controller with dependency.
  PronunciationController(this._speechRepository) : super(const PronunciationState());

  final SpeechRepository _speechRepository;

  /// Performs evaluation for [target] and [transcript].
  Future<void> evaluate(String target, String transcript) async {
    state = state.copyWith(isEvaluating: true);
    final result = await _speechRepository.evaluate(target, transcript);
    state = result.fold(
      (failure) => state.copyWith(
        isEvaluating: false,
        feedbackMessage: failure.message,
      ),
      (score) => state.copyWith(
        isEvaluating: false,
        score: score,
        feedbackMessage: _feedbackForScore(score.score),
      ),
    );
  }

  String _feedbackForScore(double score) {
    if (score >= 80) return 'Good';
    if (score >= 60) return 'Okay';
    return 'Try again';
  }
}

/// Provides the controller to the view layer.
final pronunciationControllerProvider =
    StateNotifierProvider<PronunciationController, PronunciationState>((ref) {
  final repo = ref.read(speechRepositoryProvider);
  return PronunciationController(repo);
});
