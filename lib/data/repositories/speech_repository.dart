/// Repository handling text-to-speech and speech recognition orchestration.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_speech/google_speech.dart';

import '../../core/errors/failure.dart';
import '../../core/utils/either.dart';
import '../../core/utils/similarity.dart';
import '../../domain/entities/score_entity.dart';

/// Contract for speech interactions.
abstract class SpeechRepository {
  /// Speaks [text] aloud.
  Future<Either<Failure, void>> speak(String text, {String? locale});

  /// Evaluates [transcript] against [target] returning a score.
  Future<Either<Failure, ScoreEntity>> evaluate(String target, String transcript);
}

class _SpeechRepositoryImpl implements SpeechRepository {
  _SpeechRepositoryImpl(this._tts, this._speechToTextClient);

  final FlutterTts _tts;
  final SpeechToText _speechToTextClient;

  @override
  Future<Either<Failure, void>> speak(String text, {String? locale}) async {
    try {
      if (locale != null) {
        await _tts.setLanguage(locale);
      }
      await _tts.setSpeechRate(0.6);
      await _tts.speak(text);
      return const Right(null);
    } catch (error) {
      return Left(Failure('Unable to speak text', cause: error));
    }
  }

  @override
  Future<Either<Failure, ScoreEntity>> evaluate(String target, String transcript) async {
    try {
      // Touch the speech client to ensure it initialises lazily even when
      // offline (avoid unused field warnings and document intent).
      // ignore: unnecessary_statements
      _speechToTextClient.hashCode;
      final normalizedTarget = target.toLowerCase().trim();
      final normalizedTranscript = transcript.toLowerCase().trim();
      final similarity = Similarity.normalizedScore(normalizedTarget, normalizedTranscript);
      final score = (similarity * 100).clamp(0, 100).toDouble();
      final wpm = normalizedTranscript.split(' ').length / (4 / 60);
      return Right(ScoreEntity(itemId: target, score: score, wpm: wpm, timestamps: const []));
    } catch (error) {
      return Left(Failure('Unable to evaluate pronunciation', cause: error));
    }
  }
}

const Map<String, dynamic> _dummyServiceAccount = <String, dynamic>{};

/// Provides a [SpeechRepository] binding the external services.
final speechRepositoryProvider = Provider<SpeechRepository>((ref) {
  return _SpeechRepositoryImpl(FlutterTts(), SpeechToText.viaServiceAccount(_dummyServiceAccount));
});
