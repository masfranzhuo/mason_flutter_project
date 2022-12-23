import 'package:flutter_project/features/users/database/schemas/location_isar.dart';
import 'package:flutter_project/features/users/database/schemas/user_isar.dart';

import 'model_helpers.dart';

LocationIsar locationIsar = LocationIsar.fromJson(user.location!.toJson());
UserIsar userIsar = UserIsar.fromJson(user.toJson());
