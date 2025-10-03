/// Provides local data access powered by Hive (named `isar_provider` to match
/// project structure requirements).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Name for the session log box.
const String sessionBoxName = 'session_logs';

/// Name for pronunciation scores box.
const String scoreBoxName = 'pronunciation_scores';

/// Name for settings storage box.
const String settingsBoxName = 'settings_box';

/// Opens a Hive box lazily and exposes it through Riverpod.
final sessionBoxProvider = FutureProvider<Box<Map>>((ref) async {
  return Hive.openBox<Map>(sessionBoxName);
});

/// Opens the pronunciation score box lazily.
final scoreBoxProvider = FutureProvider<Box<Map>>((ref) async {
  return Hive.openBox<Map>(scoreBoxName);
});

/// Opens settings box storing key-value preferences.
final settingsBoxProvider = FutureProvider<Box>((ref) async {
  return Hive.openBox(settingsBoxName);
});
