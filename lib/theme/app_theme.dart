/// Exposes theming configuration for the application.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Encapsulates the light/dark theme data and current mode.
class ThemeBundle {
  /// Constructs a bundle with [light], [dark], and [mode].
  const ThemeBundle({required this.light, required this.dark, required this.mode});

  /// Light theme configuration.
  final ThemeData light;

  /// Dark theme configuration.
  final ThemeData dark;

  /// Currently selected mode.
  final ThemeMode mode;
}

/// Riverpod provider delivering the theme bundle.
final appThemeProvider = Provider<ThemeBundle>((ref) {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A90E2)),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16),
    ),
  );
  return ThemeBundle(
    light: base,
    dark: ThemeData.dark(useMaterial3: true),
    mode: ThemeMode.system,
  );
});
