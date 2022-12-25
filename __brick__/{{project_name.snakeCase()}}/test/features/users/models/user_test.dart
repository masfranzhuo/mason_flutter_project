import 'package:{{project_name.snakeCase()}}/features/users/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/model_helpers.dart';

void main() {
  group('User', () {
    test('fromJson', () {
      final result = User.fromJson(userJson);
      expect(result, user);
    });
  });
}
