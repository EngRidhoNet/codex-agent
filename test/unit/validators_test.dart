import 'package:flutter_test/flutter_test.dart';

import 'package:aura_plus/core/utils/validators.dart';

void main() {
  test('isNotEmpty returns true for non-empty strings', () {
    expect(Validators.isNotEmpty('hello'), isTrue);
    expect(Validators.isNotEmpty(''), isFalse);
  });

  test('inRange validates numeric ranges', () {
    expect(Validators.inRange(5, 0, 10), isTrue);
    expect(Validators.inRange(-1, 0, 10), isFalse);
  });
}
