import 'package:{{project_name.snakeCase()}}/src/entities/location_isar.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user_isar.dart';
import 'package:flutter_test/flutter_test.dart';

import 'entity_helpers.dart';
import 'isar_entity_helpers.dart';

void main() {
  group('LocationIsar', () {
    test('fromLocation', () {
      var result = LocationIsar.fromLocation(user.location!);
      expect(result.street, locationIsar.street);
      expect(result.city, locationIsar.city);
      expect(result.state, locationIsar.state);
      expect(result.country, locationIsar.country);
      expect(result.timezone, locationIsar.timezone);
    });

    test('toLocation', () {
      final result = locationIsar.toLocation();
      expect(result, user.location);
    });
  });

  group('UserIsar', () {
    test('fromUser', () {
      var result = UserIsar.fromUser(user);
      expect(result.idString, userIsar.idString);
      expect(
        result.location.value?.idString,
        userIsar.location.value?.idString,
      );
    });

    test('toUser', () {
      final result = userIsar.toUser();
      expect(result, user);
    });
  });
}
