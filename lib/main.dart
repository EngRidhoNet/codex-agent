/// Entry point for the AURA+ application.
///
/// This file wires Flutter bindings, initializes storage, and launches the
/// root [AuraApp].
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.ensureInitialized();
  await initializeLogging();
  runApp(const ProviderScope(child: AuraApp()));
}
