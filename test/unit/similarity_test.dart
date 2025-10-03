import 'package:aura_plus/core/utils/similarity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Similarity.levenshtein', () {
    test('returns zero for identical strings', () {
      expect(Similarity.levenshtein('flutter', 'flutter'), 0);
    });

    test('handles empty strings', () {
      expect(Similarity.levenshtein('', ''), 0);
      expect(Similarity.levenshtein('aura', ''), 4);
      expect(Similarity.levenshtein('', 'plus'), 4);
    });

    test('computes known distance for kitten vs sitting', () {
      expect(Similarity.levenshtein('kitten', 'sitting'), 3);
    });
  });

  group('Similarity.normalizedScore', () {
    test('returns 1 for identical strings', () {
      expect(Similarity.normalizedScore('hello', 'hello'), 1);
    });

    test('returns 0 when compared with empty string', () {
      expect(Similarity.normalizedScore('hello', ''), 0);
      expect(Similarity.normalizedScore('', 'hello'), 0);
    });

    test('returns value between 0 and 1 for partial matches', () {
      final score = Similarity.normalizedScore('kitten', 'sitting');
      expect(score, closeTo(4 / 7, 1e-6));
    });
  });
}
