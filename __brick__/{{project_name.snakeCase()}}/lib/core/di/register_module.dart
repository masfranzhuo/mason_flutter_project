import 'package:{{project_name.snakeCase()}}/core/config/base_config.dart';
import 'package:{{project_name.snakeCase()}}/features/users/database/database.dart';
import 'package:{{project_name.snakeCase()}}/features/users/database/schemas/user_isar.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

@module
abstract class RegisterModule {
  String get baseUrl => GetIt.I<BaseConfig>().baseUrl;

  @preResolve
  Future<Isar> get isar async => await Isar.open(
        [UserIsarSchema],
        directory: (await getApplicationSupportDirectory()).path,
        name: GetIt.I<BaseConfig>().appName,
      );

  /// Drift local storage
  ///
  Database get database => Database();
}
