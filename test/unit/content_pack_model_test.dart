import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

import 'package:aura_plus/data/models/content_pack.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ContentPackModel parses JSON correctly', () async {
    final jsonString = await rootBundle.loadString('assets/content_packs/pack_basic_animals_v1.json');
    final map = json.decode(jsonString) as Map<String, dynamic>;
    final model = ContentPackModel.fromJson(map);
    expect(model.items.length, 2);
    expect(model.items.first.id, 'cat');
  });
}
