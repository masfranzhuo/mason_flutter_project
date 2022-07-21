import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import 'entity_helpers.dart';

void main() {
  group('User', () {
    test('fromJson', () {
      final result = User.fromJson(userJson);
      expect(result, user);
    });
  });
}
