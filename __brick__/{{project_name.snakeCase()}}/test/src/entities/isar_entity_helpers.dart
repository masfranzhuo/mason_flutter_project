import 'package:{{project_name.snakeCase()}}/src/entities/location_isar.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user_isar.dart';

import 'entity_helpers.dart';

LocationIsar locationIsar = LocationIsar()
  ..idString = user.id
  ..street = user.location!.street
  ..city = user.location!.city
  ..state = user.location!.state
  ..country = user.location!.country
  ..timezone = user.location!.timezone;

UserIsar userIsar = UserIsar()
  ..idString = user.id
  ..title = user.title
  ..firstName = user.firstName
  ..lastName = user.lastName
  ..picture = user.picture
  ..dateOfBirth = user.dateOfBirth
  ..registerDate = user.registerDate
  ..gender = user.gender
  ..email = user.email
  ..phone = user.phone
  ..location.value = locationIsar;
