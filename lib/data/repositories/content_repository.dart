/// Repository responsible for loading content packs from assets or remote.
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failure.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/content_pack_entity.dart';
import '../../domain/entities/vocab_entity.dart';
import '../datasources/remote/content_api.dart';
import '../models/content_pack.dart';

/// List of bundled content pack asset paths.
const List<String> defaultPackPaths = <String>[
  'assets/content_packs/pack_basic_animals_v1.json',
];

/// Abstraction describing the content repository contract.
abstract class ContentRepository {
  /// Loads all bundled content packs.
  Future<Either<Failure, List<ContentPackEntity>>> loadLocalPacks();

  /// Returns a single pack by [id].
  Future<Either<Failure, ContentPackEntity?>> getPackById(String id);

  /// Searches vocabulary items across packs.
  Future<Either<Failure, List<VocabEntity>>> searchItems(String query);
}

class _ContentRepositoryImpl implements ContentRepository {
  _ContentRepositoryImpl(this._api);

  final ContentApi _api;

  List<ContentPackEntity>? _cache;

  @override
  Future<Either<Failure, List<ContentPackEntity>>> loadLocalPacks() async {
    try {
      if (_cache != null) {
        return Right(_cache!);
      }
      final packs = <ContentPackEntity>[];
      for (final path in defaultPackPaths) {
        final json = await _api.loadAssetJson(path);
        packs.add(ContentPackModel.fromJson(json).toEntity());
      }
      _cache = packs;
      return Right(packs);
    } on PlatformException catch (error) {
      return Left(Failure('Failed to load content packs', cause: error));
    }
  }

  @override
  Future<Either<Failure, ContentPackEntity?>> getPackById(String id) async {
    final result = await loadLocalPacks();
    return result.map((packs) => packs.firstWhere((pack) => pack.id == id, orElse: () => null));
  }

  @override
  Future<Either<Failure, List<VocabEntity>>> searchItems(String query) async {
    final lower = query.toLowerCase();
    final packs = await loadLocalPacks();
    return packs.map((entities) {
      final results = <VocabEntity>[];
      for (final pack in entities) {
        results.addAll(pack.items.where((item) {
          return item.label.values.any((value) => value.toLowerCase().contains(lower)) ||
              item.tags.any((tag) => tag.toLowerCase().contains(lower));
        }));
      }
      return results;
    });
  }
}

/// Provides a singleton instance of [ContentRepository].
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return _ContentRepositoryImpl(ContentApi());
});
