import 'package:{{project_name.snakeCase()}}/core/services/services.dart';
import 'package:{{project_name.snakeCase()}}/features/users/data_sources/user_network_data_source.dart';
import 'package:{{project_name.snakeCase()}}/features/users/data_sources/user_local_data_source.dart';
import 'package:{{project_name.snakeCase()}}/features/users/database/dao/user_dao.dart';
import 'package:{{project_name.snakeCase()}}/features/users/repositories/user_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/users/usecases/get_user.dart';
import 'package:{{project_name.snakeCase()}}/features/users/usecases/get_users.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  /// services
  ///
  HttpClientService,
  LocalStorageService,
  InternetConnectionService,

  /// dao
  ///
  UserDao,

  /// data sources
  ///
  UserNetworkDataSource,
  UserLocalDataSource,

  /// repositories
  ///
  UserRepository,

  /// use cases
  ///
  GetUser,
  GetUsers,
])
class MockGeneratorHelpers {}
