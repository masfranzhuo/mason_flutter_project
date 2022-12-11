import 'package:{{project_name.snakeCase()}}/core/services/services.dart';
import 'package:{{project_name.snakeCase()}}/features/users/data_sources/user_data_source.dart';
import 'package:{{project_name.snakeCase()}}/features/users/data_sources/user_local_data_source.dart';
import 'package:{{project_name.snakeCase()}}/features/users/data_sources/user_sqflite_data_source.dart';
import 'package:{{project_name.snakeCase()}}/features/users/repositories/user_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/users/usecases/get_user.dart';
import 'package:{{project_name.snakeCase()}}/features/users/usecases/get_users.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  /// services
  ///
  HttpClientService,
  HiveService,
  InternetConnectionService,
  SqfliteService,

  /// data sources
  ///
  UserDataSource,
  UserLocalDataSource,
  UserSqfliteDataSource,

  /// repositories
  ///
  UserRepository,

  /// use cases
  ///
  GetUser,
  GetUsers,
])
class MockGeneratorHelpers {}
