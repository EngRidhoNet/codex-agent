/// Domain entity describing a vocabulary entry.
class VocabEntity {
  /// Creates a vocabulary entity.
  const VocabEntity({
    required this.id,
    required this.label,
    required this.modelPath,
    required this.ttsText,
    required this.tags,
    required this.difficulty,
  });

  /// Unique identifier.
  final String id;

  /// Localized label map.
  final Map<String, String> label;

  /// Path to 3D asset.
  final String modelPath;

  /// Text used for TTS prompts.
  final Map<String, String> ttsText;

  /// Search tags.
  final List<String> tags;

  /// Difficulty rating.
  final int difficulty;
}
