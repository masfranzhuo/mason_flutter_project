import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:{{project_name.snakeCase()}}/core/services/http_client/interceptor.dart';
import 'package:{{project_name.snakeCase()}}/core/services/services.dart';
import 'package:injectable/injectable.dart';

abstract class HttpClientService {
  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
  Future<Response> post({
    required String path,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
  Future<Response> put({
    required String path,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
  Future<Response> patch({
    required String path,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
  Future<Response> delete({
    required String path,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}

class IHttpClientService implements HttpClientService {
  final String baseUrl;
  final Dio _dio;

  IHttpClientService({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  final IInternetConnectionService _internetConnectionService =
      IInternetConnectionService();

  void setInterceptors(BaseInterceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  @override
  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _internetConnectionService.checkConnection();
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on InternetConnectionException catch (_) {
      rethrow;
    } on DioError catch (e) {
      throw (AppException(message: e.toString()));
    }
  }

  @override
  Future<Response> post({
    required String path,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _internetConnectionService.checkConnection();
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on InternetConnectionException catch (_) {
      rethrow;
    } on DioError catch (e) {
      throw (AppException(message: e.toString()));
    }
  }

  @override
  Future<Response> put({
    required String path,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _internetConnectionService.checkConnection();
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on InternetConnectionException catch (_) {
      rethrow;
    } on DioError catch (e) {
      throw (AppException(message: e.toString()));
    }
  }

  @override
  Future<Response> patch({
    required String path,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _internetConnectionService.checkConnection();
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on InternetConnectionException catch (_) {
      rethrow;
    } on DioError catch (e) {
      throw (AppException(message: e.toString()));
    }
  }

  @override
  Future<Response> delete({
    required String path,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _internetConnectionService.checkConnection();
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on InternetConnectionException catch (_) {
      rethrow;
    } on DioError catch (e) {
      throw (AppException(message: e.toString()));
    }
  }
}

/// internal example implementation
///
@LazySingleton(as: HttpClientService)
class HttpClientServiceImpl extends IHttpClientService {
  HttpClientServiceImpl({required super.baseUrl});
}
