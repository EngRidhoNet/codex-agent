/// Provides application-wide configuration and bootstrap hooks.
import 'package:hive_flutter/hive_flutter.dart';

/// [AppConfig] is responsible for ensuring that storage layers are initialised
/// before the UI tree is rendered.
class AppConfig {
  static bool _initialized = false;

  /// Boots required services such as Hive databases.
  static Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }
    await Hive.initFlutter();
    _initialized = true;
  }
}
