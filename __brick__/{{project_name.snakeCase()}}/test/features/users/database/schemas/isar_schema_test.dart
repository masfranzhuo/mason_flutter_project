import 'package:flutter_project/features/users/database/schemas/location_isar.dart';
import 'package:flutter_project/features/users/database/schemas/user_isar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/model_helpers.dart';
import '../../../../helpers/isar_schema_helpers.dart';

void main() {
  group('LocationIsar', () {
    test('fromJson', () {
      var result = LocationIsar.fromJson(user.location!.toJson());
      expect(result.street, locationIsar.street);
      expect(result.city, locationIsar.city);
      expect(result.state, locationIsar.state);
      expect(result.country, locationIsar.country);
      expect(result.timezone, locationIsar.timezone);
    });

    test('toJson', () {
      final result = locationIsar.toJson();
      expect(result, user.location!.toJson());
    });
  });

  group('UserIsar', () {
    test('fromJson', () {
      var result = UserIsar.fromJson(user.toJson());
      expect(result.idString, userIsar.idString);
    });

    test('toJson', () {
      final result = userIsar.toJson();
      expect(result, user.toJson());
    });
  });
}
