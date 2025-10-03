/// Data model persisting pronunciation evaluation results.
import '../../domain/entities/score_entity.dart';

/// Serializable pronunciation score model.
class PronunciationScoreModel {
  /// Constructs a model instance.
  PronunciationScoreModel({
    required this.itemId,
    required this.score,
    required this.wpm,
    required this.timestamps,
  });

  /// Identifier of the associated vocabulary item.
  final String itemId;

  /// Score between 0 and 100.
  final double score;

  /// Words per minute approximation.
  final double wpm;

  /// Timestamp markers for analytics.
  final List<double> timestamps;

  /// Creates a model from map data.
  factory PronunciationScoreModel.fromMap(Map data) {
    return PronunciationScoreModel(
      itemId: data['itemId'] as String,
      score: (data['score'] as num).toDouble(),
      wpm: (data['wpm'] as num).toDouble(),
      timestamps: (data['timestamps'] as List).map((e) => (e as num).toDouble()).toList(),
    );
  }

  /// Serialises the model into a map.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'itemId': itemId,
        'score': score,
        'wpm': wpm,
        'timestamps': timestamps,
      };

  /// Converts the model to its domain representation.
  ScoreEntity toEntity() => ScoreEntity(
        itemId: itemId,
        score: score,
        wpm: wpm,
        timestamps: timestamps,
      );
}
