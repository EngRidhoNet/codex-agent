/// Use case for loading all available content packs.
import '../../core/errors/failure.dart';
import '../../core/utils/either.dart';
import '../entities/content_pack_entity.dart';
import '../../data/repositories/content_repository.dart';

/// Executes the load content packs use case.
class LoadContentPacks {
  /// Creates an instance with the required [repository].
  LoadContentPacks(this.repository);

  /// Repository dependency.
  final ContentRepository repository;

  /// Executes the use case and returns either failure or packs.
  Future<Either<Failure, List<ContentPackEntity>>> call() {
    return repository.loadLocalPacks();
  }
}
