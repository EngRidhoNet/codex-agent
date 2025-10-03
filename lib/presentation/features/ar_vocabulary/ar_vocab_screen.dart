/// Screen hosting the AR vocabulary learning experience with fallback viewer.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../data/repositories/speech_repository.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/widgets/primary_button.dart';
import 'ar_vocab_controller.dart';

/// AR vocabulary feature screen.
class ArVocabScreen extends ConsumerWidget {
  /// Creates the screen.
  const ArVocabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arVocabControllerProvider);
    final controller = ref.read(arVocabControllerProvider.notifier);
    final speech = ref.read(speechRepositoryProvider);

    if (state.isLoading) {
      return const AppScaffold(title: 'AR Vocabulary', body: Center(child: CircularProgressIndicator()));
    }

    if (state.failure != null) {
      return AppScaffold(title: 'AR Vocabulary', body: Center(child: Text(state.failure!.message)));
    }

    final item = state.current;
    if (item == null) {
      return const AppScaffold(title: 'AR Vocabulary', body: Center(child: Text('Tidak ada konten')));
    }

    return AppScaffold(
      title: 'AR Vocabulary',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: state.isArSupported
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'AR mode aktif. Integrasikan AR anchors menggunakan ar_flutter_plugin.',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ModelViewer(
                    src: item.modelPath,
                    ar: false,
                    autoRotate: true,
                    cameraControls: true,
                  ),
          ),
          const SizedBox(height: 16),
          Text(item.label['id'] ?? item.label['en'] ?? item.id, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Putar TTS',
                  onPressed: () {
                    speech.speak(item.ttsText['id'] ?? item.ttsText['en'] ?? item.id);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Catat Sesi',
                  onPressed: controller.logView,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Sebelumnya',
                  onPressed: controller.previous,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Berikutnya',
                  onPressed: controller.next,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
