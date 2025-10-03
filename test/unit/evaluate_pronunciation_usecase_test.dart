import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:aura_plus/core/errors/failure.dart';
import 'package:aura_plus/core/utils/either.dart';
import 'package:aura_plus/data/repositories/speech_repository.dart';
import 'package:aura_plus/domain/entities/score_entity.dart';
import 'package:aura_plus/domain/usecases/evaluate_pronunciation.dart';

class _MockSpeechRepository extends Mock implements SpeechRepository {}

void main() {
  late _MockSpeechRepository repository;
  late EvaluatePronunciation usecase;

  setUp(() {
    repository = _MockSpeechRepository();
    usecase = EvaluatePronunciation(repository);
  });

  test('returns score when evaluation succeeds', () async {
    final score = ScoreEntity(itemId: 'cat', score: 90, wpm: 100, timestamps: const []);
    when(() => repository.evaluate('cat', 'cat')).thenAnswer((_) async => Right(score));

    final result = await usecase('cat', 'cat');
    expect(result, isA<Right<Failure, ScoreEntity>>());
  });
}
