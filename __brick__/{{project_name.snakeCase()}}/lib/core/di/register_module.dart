import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/location_isar.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user_isar.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

@module
abstract class RegisterModule {
  @Named('baseUrl')
  String get baseUrl => 'https://dummyapi.io/data/v1/';

  Dio dio(@Named('baseUrl') String baseUrl) =>
      Dio(BaseOptions(baseUrl: baseUrl));

  @preResolve
  Future<Box<dynamic>> get hive async => Hive.box('box');

  @preResolve
  Future<Isar> get isar async => await Isar.open(
        [LocationIsarSchema, UserIsarSchema],
        directory: (await getApplicationSupportDirectory()).path,
        inspector: true,
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
