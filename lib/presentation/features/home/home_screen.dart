/// Home screen summarising recent activity and providing feature entry points.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/failure.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../domain/entities/session_entity.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/widgets/card_progress.dart';
import '../../common/widgets/primary_button.dart';

/// Provider retrieving recent sessions for the dashboard.
final recentSessionsProvider = FutureProvider<List<SessionEntity>>((ref) async {
  final repo = ref.read(sessionRepositoryProvider);
  final result = await repo.getSessions();
  return result.fold((_) => <SessionEntity>[], (value) => value);
});

/// Simple helper computing progress ratio based on total duration.
double _computeProgress(List<SessionEntity> sessions) {
  if (sessions.isEmpty) return 0;
  final totalDuration = sessions.map((session) => session.durationSec).fold<int>(0, (a, b) => a + b);
  return (totalDuration / (sessions.length * 300)).clamp(0, 1);
}

/// Home screen widget.
class HomeScreen extends ConsumerWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSessions = ref.watch(recentSessionsProvider);
    return AppScaffold(
      title: 'AURA+',
      body: asyncSessions.when(
        data: (sessions) => _HomeContent(sessions: sessions),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _HomeError(error: error),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.sessions});

  final List<SessionEntity> sessions;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selamat datang! Mari mulai petualangan AR pertama Anda.'),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Jelajahi Konten',
            onPressed: () => GoRouter.of(context).go('/content'),
          ),
        ],
      );
    }
    final last = sessions.first;
    final progress = _computeProgress(sessions);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardProgress(title: 'Kemajuan Minggu Ini', progress: progress),
        const SizedBox(height: 16),
        Text('Sesi terakhir: ${last.feature} • ${last.durationSec}s'),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'AR Vocabulary',
          onPressed: () => GoRouter.of(context).go('/ar-vocab'),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Pronunciation Guide',
          onPressed: () => GoRouter.of(context).go('/pronunciation'),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Model Viewer',
          onPressed: () => GoRouter.of(context).go('/ar-viewer'),
        ),
      ],
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final message = error is Failure ? error.message : 'Terjadi kesalahan';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Coba lagi',
          onPressed: () => GoRouter.of(context).go('/'),
        ),
      ],
    );
  }
}
