import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:aura_plus/core/errors/failure.dart';
import 'package:aura_plus/core/utils/either.dart';
import 'package:aura_plus/data/repositories/content_repository.dart';
import 'package:aura_plus/domain/entities/content_pack_entity.dart';
import 'package:aura_plus/domain/entities/vocab_entity.dart';
import 'package:aura_plus/domain/usecases/get_vocab_by_id.dart';

class _MockContentRepository extends Mock implements ContentRepository {}

void main() {
  late _MockContentRepository repository;
  late GetVocabById usecase;
  final vocab = VocabEntity(
    id: 'cat',
    label: const {'en': 'Cat'},
    modelPath: 'path',
    ttsText: const {'en': 'Cat'},
    tags: const ['animal'],
    difficulty: 1,
  );

  setUp(() {
    repository = _MockContentRepository();
    usecase = GetVocabById(repository);
  });

  test('returns vocabulary when found', () async {
    when(() => repository.loadLocalPacks()).thenAnswer((_) async => Right([
          ContentPackEntity(
            id: 'pack',
            title: const {'en': 'title'},
            description: const {'en': 'desc'},
            language: 'en',
            items: [vocab],
          ),
        ]));

    final result = await usecase('cat');
    expect(result, isA<Right<Failure, VocabEntity?>>());
    expect(result.fold((l) => null, (r) => r), equals(vocab));
  });
}
