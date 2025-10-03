/// Screen guiding the user through pronunciation practice with feedback.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/widgets/primary_button.dart';
import 'pronunciation_controller.dart';

/// Pronunciation practice screen.
class PronunciationScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const PronunciationScreen({super.key});

  @override
  ConsumerState<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends ConsumerState<PronunciationScreen> {
  final _targetController = TextEditingController(text: 'Cat');
  final _transcriptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pronunciationControllerProvider);
    final controller = ref.read(pronunciationControllerProvider.notifier);
    return AppScaffold(
      title: 'Pronunciation Guide',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _targetController,
            decoration: const InputDecoration(labelText: 'Target phrase'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _transcriptController,
            decoration: const InputDecoration(labelText: 'Transkrip rekaman (mock)'),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: state.isEvaluating ? 'Menilai...' : 'Evaluasi',
            onPressed: state.isEvaluating
                ? null
                : () => controller.evaluate(_targetController.text, _transcriptController.text),
          ),
          const SizedBox(height: 24),
          if (state.feedbackMessage.isNotEmpty) Text('Feedback: ${state.feedbackMessage}'),
          if (state.score != null)
            Text('Score: ${state.score!.score.toStringAsFixed(1)} | WPM: ${state.score!.wpm.toStringAsFixed(1)}'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _targetController.dispose();
    _transcriptController.dispose();
    super.dispose();
  }
}
