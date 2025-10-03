import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';

import 'package:aura_plus/core/errors/failure.dart';
import 'package:aura_plus/core/utils/either.dart';
import 'package:aura_plus/data/repositories/speech_repository.dart';
import 'package:aura_plus/domain/entities/score_entity.dart';
import 'package:aura_plus/presentation/features/pronunciation/pronunciation_screen.dart';

class _FakeSpeechRepository implements SpeechRepository {
  @override
  Future<Either<Failure, ScoreEntity>> evaluate(String target, String transcript) async {
    return Right(ScoreEntity(itemId: target, score: 80, wpm: 90, timestamps: const []));
  }

  @override
  Future<Either<Failure, void>> speak(String text, {String? locale}) async {
    return const Right(null);
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Pronunciation flow shows feedback', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          speechRepositoryProvider.overrideWithValue(_FakeSpeechRepository()),
        ],
        child: const MaterialApp(home: PronunciationScreen()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Cat');
    await tester.tap(find.text('Evaluasi'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Feedback'), findsOneWidget);
  });
}
