/// Settings screen allowing customization of locale, theme, and speech options.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:hive/hive.dart';

import '../../../data/datasources/local/isar_provider.dart';
import '../../common/widgets/app_scaffold.dart';

/// Model representing user settings values.
class SettingsState {
  /// Constructs a settings state object.
  const SettingsState({
    required this.locale,
    required this.themeMode,
    required this.ttsRate,
  });

  /// Preferred locale string.
  final String locale;

  /// Preferred theme mode string.
  final String themeMode;

  /// Text-to-speech rate between 0.2 and 1.0.
  final double ttsRate;

  /// Creates a copy with updated values.
  SettingsState copyWith({String? locale, String? themeMode, double? ttsRate}) {
    return SettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      ttsRate: ttsRate ?? this.ttsRate,
    );
  }
}

/// State notifier persisting settings in Hive.
class SettingsController extends StateNotifier<SettingsState> {
  /// Creates the controller.
  SettingsController(this._box)
      : super(SettingsState(
          locale: _box.get('locale', defaultValue: 'en') as String,
          themeMode: _box.get('themeMode', defaultValue: 'system') as String,
          ttsRate: (_box.get('ttsRate', defaultValue: 0.6) as num).toDouble(),
        ));

  final Box _box;

  /// Updates locale preference.
  void updateLocale(String locale) {
    _box.put('locale', locale);
    state = state.copyWith(locale: locale);
  }

  /// Updates theme mode preference.
  void updateThemeMode(String mode) {
    _box.put('themeMode', mode);
    state = state.copyWith(themeMode: mode);
  }

  /// Updates TTS rate.
  void updateTtsRate(double rate) {
    _box.put('ttsRate', rate);
    state = state.copyWith(ttsRate: rate);
  }
}

/// Provides settings controller asynchronously.
final settingsControllerProvider = FutureProvider<SettingsController>((ref) async {
  final box = await ref.watch(settingsBoxProvider.future);
  return SettingsController(box);
});

/// Settings screen widget.
class SettingsScreen extends ConsumerWidget {
  /// Creates the settings screen.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncController = ref.watch(settingsControllerProvider);
    return asyncController.when(
      data: (controller) => _SettingsContent(controller: controller),
      loading: () => const AppScaffold(title: 'Settings', body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => AppScaffold(title: 'Settings', body: Center(child: Text(error.toString()))),
    );
  }
}

class _SettingsContent extends StatefulWidget {
  const _SettingsContent({required this.controller});

  final SettingsController controller;

  @override
  State<_SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<_SettingsContent> {
  late SettingsState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.controller.state;
    widget.controller.addListener(_onStateChanged);
  }

  void _onStateChanged(SettingsState state) {
    setState(() {
      _state = state;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings',
      body: ListView(
        children: [
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _state.locale,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'id', child: Text('Bahasa Indonesia')),
              ],
              onChanged: (value) {
                if (value != null) {
                  widget.controller.updateLocale(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<String>(
              value: _state.themeMode,
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
              ],
              onChanged: (value) {
                if (value != null) {
                  widget.controller.updateThemeMode(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Voice rate'),
            subtitle: Slider(
              value: _state.ttsRate,
              min: 0.2,
              max: 1.0,
              onChanged: widget.controller.updateTtsRate,
            ),
          ),
          ListTile(
            title: const Text('About'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => GoRouter.of(context).go('/settings/about'),
          ),
        ],
      ),
    );
  }
}
