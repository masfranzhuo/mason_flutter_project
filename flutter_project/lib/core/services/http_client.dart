import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

abstract class HttpClientService {
  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}

@LazySingleton(as: HttpClientService)
class HttpClientServiceImpl implements HttpClientService {
  final Dio dio;

  HttpClientServiceImpl({required this.dio});

  @override
  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: <String, dynamic>{'app-id': dotenv.env['APP_ID']},
        ),
      );

      return response;
    } on DioError catch (e) {
      return e.response!;
    }
  }
}
