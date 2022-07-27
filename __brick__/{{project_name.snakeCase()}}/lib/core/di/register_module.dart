import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @Named('baseUrl')
  String get baseUrl => 'https://dummyapi.io/data/v1/';

  Dio dio(@Named('baseUrl') String baseUrl) =>
      Dio(BaseOptions(baseUrl: baseUrl));

  @preResolve
  Future<Box<dynamic>> get hive async => Hive.box('box');

  // TODO: sqflite only works for mobile device || refactor Sqflite
  // @preResolve
  // Future<Database> get database async => await openDatabase(
  //       join(await getDatabasesPath(), 'database.db'),
  //       version: 1,
  //       onCreate: (Database database, int version) async {
  //         await database.execute(DatabaseSql.createTableUser);
  //       },
  //     );
}
