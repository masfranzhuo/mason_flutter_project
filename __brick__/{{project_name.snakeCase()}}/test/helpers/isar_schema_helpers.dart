import 'package:{{project_name.snakeCase()}}/src/database/schemas/location_isar.dart';
import 'package:{{project_name.snakeCase()}}/src/database/schemas/user_isar.dart';

import 'entity_helpers.dart';

LocationIsar locationIsar = LocationIsar.fromJson(user.location!.toJson());
UserIsar userIsar = UserIsar.fromJson(user.toJson());
