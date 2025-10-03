/// Data model representing a content pack of vocabulary items.
import '../../domain/entities/content_pack_entity.dart';
import 'vocab_item.dart';

/// Serializable content pack model.
class ContentPackModel {
  /// Constructs a [ContentPackModel] instance.
  ContentPackModel({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.items,
  });

  /// Unique identifier.
  final String id;

  /// Translated titles keyed by locale.
  final Map<String, String> title;

  /// Translated descriptions.
  final Map<String, String> description;

  /// Base language for the pack.
  final String language;

  /// Collection of vocabulary items.
  final List<VocabItemModel> items;

  /// Builds the model from JSON.
  factory ContentPackModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List).cast<Map<String, dynamic>>();
    return ContentPackModel(
      id: json['id'] as String,
      title: Map<String, String>.from(json['title'] as Map),
      description: Map<String, String>.from(json['description'] as Map),
      language: json['language'] as String,
      items: rawItems.map(VocabItemModel.fromJson).toList(),
    );
  }

  /// Converts the model into an immutable domain entity.
  ContentPackEntity toEntity() => ContentPackEntity(
        id: id,
        title: title,
        description: description,
        language: language,
        items: items.map((item) => item.toEntity()).toList(),
      );
}
