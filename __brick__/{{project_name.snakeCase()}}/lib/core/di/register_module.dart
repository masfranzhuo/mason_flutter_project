import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @Named('baseUrl')
  String get baseUrl => 'https://dummyapi.io/data/v1/';

  @lazySingleton
  Dio dio(@Named('baseUrl') String baseUrl) =>
      Dio(BaseOptions(baseUrl: baseUrl));
}
