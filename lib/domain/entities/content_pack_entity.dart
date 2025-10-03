/// Domain entity for content pack metadata and items.
import 'vocab_entity.dart';

/// Immutable representation of a content pack.
class ContentPackEntity {
  /// Builds a content pack entity.
  const ContentPackEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.items,
  });

  /// Unique identifier.
  final String id;

  /// Localized titles keyed by locale code.
  final Map<String, String> title;

  /// Localized descriptions.
  final Map<String, String> description;

  /// Base language for the pack.
  final String language;

  /// Collection of vocabulary entries.
  final List<VocabEntity> items;
}
