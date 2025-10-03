/// Screen displaying available content packs with search and filter controls.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/failure.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../domain/entities/content_pack_entity.dart';
import '../../common/widgets/app_scaffold.dart';

/// Provider loading packs and exposing them for the UI.
final contentPacksProvider = FutureProvider<List<ContentPackEntity>>((ref) async {
  final repo = ref.read(contentRepositoryProvider);
  final result = await repo.loadLocalPacks();
  return result.fold((failure) => throw failure, (value) => value);
});

/// Provider storing the current search query.
final contentSearchProvider = StateProvider<String>((ref) => '');

/// Provider storing difficulty filter (null for all).
final contentDifficultyProvider = StateProvider<int?>((ref) => null);

/// Composed provider returning filtered packs.
final filteredPacksProvider = Provider<AsyncValue<List<ContentPackEntity>>>((ref) {
  final query = ref.watch(contentSearchProvider);
  final difficulty = ref.watch(contentDifficultyProvider);
  final asyncPacks = ref.watch(contentPacksProvider);
  return asyncPacks.whenData((packs) {
    return packs.where((pack) {
      final matchesQuery = query.isEmpty ||
          pack.title.values.any((value) => value.toLowerCase().contains(query.toLowerCase()));
      final matchesDifficulty = difficulty == null ||
          pack.items.any((item) => item.difficulty == difficulty);
      return matchesQuery && matchesDifficulty;
    }).toList();
  });
});

/// Content library screen widget.
class ContentListScreen extends ConsumerWidget {
  /// Creates the content list screen.
  const ContentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPacks = ref.watch(filteredPacksProvider);
    return AppScaffold(
      title: 'Content Library',
      body: asyncPacks.when(
        data: (packs) => _ContentList(packs: packs),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          final message = error is Failure ? error.message : 'Tidak dapat memuat konten';
          return Center(child: Text(message));
        },
      ),
    );
  }
}

class _ContentList extends ConsumerWidget {
  const _ContentList({required this.packs});

  final List<ContentPackEntity> packs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Cari konten'),
          onChanged: (value) => ref.read(contentSearchProvider.notifier).state = value,
        ),
        const SizedBox(height: 12),
        DropdownButton<int?>(
          value: ref.watch(contentDifficultyProvider),
          hint: const Text('Difficulty'),
          items: const [
            DropdownMenuItem(value: null, child: Text('Semua tingkat')),
            DropdownMenuItem(value: 1, child: Text('Level 1')),
            DropdownMenuItem(value: 2, child: Text('Level 2')),
            DropdownMenuItem(value: 3, child: Text('Level 3')),
          ],
          onChanged: (value) => ref.read(contentDifficultyProvider.notifier).state = value,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: packs.length,
            itemBuilder: (context, index) {
              final pack = packs[index];
              return Card(
                child: ListTile(
                  title: Text(pack.title['id'] ?? pack.title.values.first),
                  subtitle: Text(pack.description['id'] ?? pack.description.values.first),
                  onTap: () => GoRouter.of(context).go('/content/${pack.id}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
