/// Utility functions for computing similarity between strings.
///
/// The helpers in this file provide lightweight Levenshtein distance
/// calculations and a normalised similarity score (0.0 - 1.0). These metrics
/// are used by the pronunciation evaluation pipeline to provide feedback when
/// offline.
class Similarity {
  /// Computes the Levenshtein edit distance between two strings.
  ///
  /// The implementation is intentionally iterative to avoid recursion overhead
  /// and works with Unicode-safe `runes` by comparing code units.
  static int levenshtein(String a, String b) {
    if (identical(a, b) || a == b) {
      return 0;
    }
    if (a.isEmpty) {
      return b.length;
    }
    if (b.isEmpty) {
      return a.length;
    }

    final rows = a.length + 1;
    final cols = b.length + 1;
    final matrix = List.generate(rows, (_) => List<int>.filled(cols, 0));

    for (var i = 0; i < rows; i++) {
      matrix[i][0] = i;
    }
    for (var j = 0; j < cols; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i < rows; i++) {
      for (var j = 1; j < cols; j++) {
        final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
        final deletion = matrix[i - 1][j] + 1;
        final insertion = matrix[i][j - 1] + 1;
        final substitution = matrix[i - 1][j - 1] + cost;
        final min = deletion < insertion
            ? (deletion < substitution ? deletion : substitution)
            : (insertion < substitution ? insertion : substitution);
        matrix[i][j] = min;
      }
    }

    return matrix[rows - 1][cols - 1];
  }

  /// Returns a normalised similarity score between 0.0 and 1.0.
  ///
  /// When both strings are empty the similarity is `1.0`, otherwise the score
  /// is computed as `(maxLength - distance) / maxLength`.
  static double normalizedScore(String a, String b) {
    if (a.isEmpty && b.isEmpty) {
      return 1;
    }
    final maxLength = a.length > b.length ? a.length : b.length;
    if (maxLength == 0) {
      return 1;
    }
    final distance = levenshtein(a, b).clamp(0, maxLength);
    final score = (maxLength - distance) / maxLength;
    return score.clamp(0, 1).toDouble();
  }
}
