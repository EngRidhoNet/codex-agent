import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aura_plus/domain/entities/content_pack_entity.dart';
import 'package:aura_plus/domain/entities/vocab_entity.dart';
import 'package:aura_plus/presentation/features/content/content_list_screen.dart';

void main() {
  final pack = ContentPackEntity(
    id: 'pack',
    title: const {'en': 'Animals'},
    description: const {'en': 'Desc'},
    language: 'en',
    items: const [VocabEntity(id: 'cat', label: {'en': 'Cat'}, modelPath: 'path', ttsText: {'en': 'Cat'}, tags: ['animal'], difficulty: 1)],
  );

  testWidgets('Content list shows packs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentPacksProvider.overrideWithValue(AsyncValue.data([pack])),
        ],
        child: const MaterialApp(home: ContentListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Animals'), findsOneWidget);
  });
}
