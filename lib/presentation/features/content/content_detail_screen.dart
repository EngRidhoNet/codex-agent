/// Detail screen showing content pack metadata and vocabulary list.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/content_repository.dart';
import '../../../domain/entities/content_pack_entity.dart';
import '../../common/widgets/app_scaffold.dart';

/// Screen for displaying a single content pack's detail.
class ContentDetailScreen extends ConsumerWidget {
  /// Builds the screen with [contentPackId].
  const ContentDetailScreen({super.key, required this.contentPackId});

  /// Identifier of the pack to display.
  final String contentPackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(contentRepositoryProvider);
    return FutureBuilder(
      future: repo.getPackById(contentPackId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            return AppScaffold(title: 'Detail', body: Center(child: Text(snapshot.error.toString())));
          }
          return const AppScaffold(title: 'Detail', body: Center(child: CircularProgressIndicator()));
        }
        final result = snapshot.data!;
        return result.fold(
          (failure) => AppScaffold(title: 'Detail', body: Center(child: Text(failure.message))),
          (pack) => AppScaffold(
            title: pack?.title['id'] ?? pack?.title['en'] ?? 'Detail',
            body: _PackBody(pack: pack),
          ),
        );
      },
    );
  }
}

class _PackBody extends StatelessWidget {
  const _PackBody({required this.pack});

  final ContentPackEntity? pack;

  @override
  Widget build(BuildContext context) {
    if (pack == null) {
      return const Center(child: Text('Konten tidak ditemukan'));
    }
    return ListView.builder(
      itemCount: pack!.items.length,
      itemBuilder: (context, index) {
        final item = pack!.items[index];
        return Card(
          child: ListTile(
            title: Text(item.label['id'] ?? item.label['en'] ?? item.id),
            subtitle: Text('Kesulitan: ${item.difficulty}'),
          ),
        );
      },
    );
  }
}
