import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:aura_plus/core/errors/failure.dart';
import 'package:aura_plus/core/utils/either.dart';
import 'package:aura_plus/data/repositories/content_repository.dart';
import 'package:aura_plus/domain/entities/content_pack_entity.dart';
import 'package:aura_plus/domain/entities/vocab_entity.dart';
import 'package:aura_plus/domain/usecases/load_content_packs.dart';

class _MockContentRepository extends Mock implements ContentRepository {}

void main() {
  late _MockContentRepository repository;
  late LoadContentPacks usecase;

  setUp(() {
    repository = _MockContentRepository();
    usecase = LoadContentPacks(repository);
  });

  test('returns packs when repository succeeds', () async {
    final pack = ContentPackEntity(
      id: 'id',
      title: const {'en': 'title'},
      description: const {'en': 'desc'},
      language: 'en',
      items: const [VocabEntity(id: '1', label: {'en': 'Cat'}, modelPath: 'path', ttsText: {'en': 'Cat'}, tags: ['animal'], difficulty: 1)],
    );
    when(() => repository.loadLocalPacks()).thenAnswer((_) async => Right([pack]));

    final result = await usecase();
    expect(result, isA<Right<Failure, List<ContentPackEntity>>>());
  });
}
