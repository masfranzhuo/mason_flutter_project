import 'package:flutter_project/core/services/services.dart';
import 'package:flutter_project/features/users/data_sources/user_data_source.dart';
import 'package:flutter_project/features/users/data_sources/user_local_data_source.dart';
import 'package:flutter_project/features/users/data_sources/user_sqflite_data_source.dart';
import 'package:flutter_project/features/users/repositories/user_repository.dart';
import 'package:flutter_project/features/users/usecases/get_user.dart';
import 'package:flutter_project/features/users/usecases/get_users.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  /// services
  ///
  HttpClientService,
  LocalStorageService,
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
