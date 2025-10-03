/// Centralized routing configuration using go_router.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/features/ar_viewer/ar_viewer_screen.dart';
import '../presentation/features/ar_vocabulary/ar_vocab_screen.dart';
import '../presentation/features/content/content_detail_screen.dart';
import '../presentation/features/content/content_list_screen.dart';
import '../presentation/features/home/home_screen.dart';
import '../presentation/features/pronunciation/pronunciation_screen.dart';
import '../presentation/features/settings/about_screen.dart';
import '../presentation/features/settings/settings_screen.dart';

/// Provides the [GoRouter] instance for navigation.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'content',
            name: 'content_list',
            builder: (context, state) => const ContentListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'content_detail',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return ContentDetailScreen(contentPackId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'ar-vocab',
            name: 'ar_vocab',
            builder: (context, state) => const ArVocabScreen(),
          ),
          GoRoute(
            path: 'ar-viewer',
            name: 'ar_viewer',
            builder: (context, state) => const ArViewerScreen(),
          ),
          GoRoute(
            path: 'pronunciation',
            name: 'pronunciation',
            builder: (context, state) => const PronunciationScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'about',
                name: 'about',
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ' + state.error.toString())),
    ),
  );
});
