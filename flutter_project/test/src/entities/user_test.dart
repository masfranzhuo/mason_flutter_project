import 'package:flutter_project/src/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import 'entity_helpers.dart';

void main() {
  group('Product', () {
    test('fromJson', () {
      final result = User.fromJson(userJson);
      expect(result, user);
    });
  });
}
