import 'package:dio/dio.dart';
import 'package:flutter_project/core/base/exception/exception.dart';
import 'package:flutter_project/core/services/internet_connection.dart';
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

@LazySingleton(as: HttpClientService)
class HttpClientServiceImpl implements HttpClientService {
  final Dio dio;
  final InternetConnectionService internetConnectionService;

  HttpClientServiceImpl({
    required this.dio,
    required this.internetConnectionService,
  });

  @override
  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await internetConnectionService.checkConnection();
      final response = await dio.get(
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
      await internetConnectionService.checkConnection();
      final response = await dio.post(
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
      await internetConnectionService.checkConnection();
      final response = await dio.put(
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
      await internetConnectionService.checkConnection();
      final response = await dio.patch(
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
      await internetConnectionService.checkConnection();
      final response = await dio.delete(
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
