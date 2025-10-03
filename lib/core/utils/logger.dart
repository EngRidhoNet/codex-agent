/// Provides simple logging utilities for development and diagnostics.
import 'dart:developer' as developer;

/// Initializes the logging system. Currently it is a no-op placeholder to keep
/// the architecture extensible.
Future<void> initializeLogging() async {}

/// Writes [message] to the developer console.
void logInfo(String message) {
  developer.log(message, name: 'AURA+');
}
