/// Data model representing a vocabulary item backed by assets.
import '../../domain/entities/vocab_entity.dart';

/// Serializable vocabulary item model.
class VocabItemModel {
  /// Creates model from JSON friendly data.
  VocabItemModel({
    required this.id,
    required this.label,
    required this.modelPath,
    required this.ttsText,
    required this.tags,
    required this.difficulty,
  });

  /// Item identifier.
  final String id;

  /// Localised labels keyed by locale code.
  final Map<String, String> label;

  /// Path to the GLB/GLTF asset.
  final String modelPath;

  /// Text to be used for text-to-speech.
  final Map<String, String> ttsText;

  /// Tags aiding search and filtering.
  final List<String> tags;

  /// Relative difficulty.
  final int difficulty;

  /// Creates an instance from JSON.
  factory VocabItemModel.fromJson(Map<String, dynamic> json) {
    return VocabItemModel(
      id: json['id'] as String,
      label: Map<String, String>.from(json['label'] as Map),
      modelPath: json['modelPath'] as String,
      ttsText: Map<String, String>.from(json['ttsText'] as Map),
      tags: (json['tags'] as List).cast<String>(),
      difficulty: json['difficulty'] as int,
    );
  }

  /// Converts the model into an entity.
  VocabEntity toEntity() => VocabEntity(
        id: id,
        label: label,
        modelPath: modelPath,
        ttsText: ttsText,
        tags: tags,
        difficulty: difficulty,
      );
}
