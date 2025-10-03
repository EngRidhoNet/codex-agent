/// Use case retrieving a vocabulary item by identifier.
import '../../core/errors/failure.dart';
import '../../core/utils/either.dart';
import '../entities/vocab_entity.dart';
import '../../data/repositories/content_repository.dart';

/// Returns a [VocabEntity] for the given id.
class GetVocabById {
  /// Constructs the use case with a [repository].
  GetVocabById(this.repository);

  /// Content repository dependency.
  final ContentRepository repository;

  /// Loads the vocabulary item matching [id].
  Future<Either<Failure, VocabEntity?>> call(String id) async {
    final packs = await repository.loadLocalPacks();
    return packs.map((entities) {
      for (final pack in entities) {
        for (final item in pack.items) {
          if (item.id == id) {
            return item;
          }
        }
      }
      return null;
    });
  }
}
