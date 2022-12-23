import 'package:dio/dio.dart';
import 'package:flutter_project/core/config/base_config.dart';
import 'package:flutter_project/features/users/database/schemas/user_isar.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

@module
abstract class RegisterModule {
  Dio dio() => Dio(BaseOptions(baseUrl: GetIt.I<BaseConfig>().baseUrl));

  @preResolve
  Future<Box<dynamic>> get hive async => Hive.box('box');

  @preResolve
  Future<Isar> get isar async => await Isar.open(
        [UserIsarSchema],
        directory: (await getApplicationSupportDirectory()).path,
        name: GetIt.I<BaseConfig>().appName,
      );

  /// sqflite only works for mobile device currently
  ///
  // @preResolve
  // Future<Database> get database async => await openDatabase(
  //       join(await getDatabasesPath(), 'database.db'),
  //       version: 1,
  //       onCreate: (Database database, int version) async {
  //         await database.execute(DatabaseSql.createTableUser);
  //       },
  //     );
}
