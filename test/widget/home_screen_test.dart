import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aura_plus/presentation/features/home/home_screen.dart';

void main() {
  testWidgets('Home screen shows empty state when no sessions', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        overrides: [
          recentSessionsProvider.overrideWith((ref) async => []),
        ],
        child: MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Selamat datang'), findsOneWidget);
  });
}
