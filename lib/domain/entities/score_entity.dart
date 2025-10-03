/// Domain entity describing a pronunciation evaluation result.
class ScoreEntity {
  /// Creates a score entity.
  const ScoreEntity({
    required this.itemId,
    required this.score,
    required this.wpm,
    required this.timestamps,
  });

  /// Associated vocabulary item identifier.
  final String itemId;

  /// Score between 0 and 100.
  final double score;

  /// Words per minute proxy.
  final double wpm;

  /// Timestamp markers capturing phoneme timing.
  final List<double> timestamps;
}
