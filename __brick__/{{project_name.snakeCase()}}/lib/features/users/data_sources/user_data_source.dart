import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project/core/base/data_source/data_source.dart';
import 'package:flutter_project/core/base/exception/exception.dart';
import 'package:flutter_project/core/services/http_client.dart';
import 'package:flutter_project/core/config/general_config.dart';
import 'package:flutter_project/features/users/models/user.dart';
import 'package:injectable/injectable.dart';

abstract class UserDataSource extends AppDataSource {
  Future<List<User>> getUsers({
    required int page,
    int limit = PaginationConfig.limit,
  });
  Future<User> getUser({required String id});
}

@LazySingleton(as: UserDataSource)
class UserDataSourceImpl implements UserDataSource {
  final HttpClientService client;

  UserDataSourceImpl({required this.client});

  @override
  Future<List<User>> getUsers({
    required int page,
    int limit = PaginationConfig.limit,
  }) async {
    try {
      final result = await client.get(
        path: 'user',
        queryParameters: {'limit': limit, 'page': page},
        options: Options(
          headers: <String, dynamic>{'app-id': dotenv.env['APP_ID']},
        ),
      );

      final data = List<dynamic>.from(result.data['data'] ?? []).toList();

      return List<Map<String, dynamic>>.from(data)
          .map((item) => User.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on AppException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<User> getUser({required String id}) async {
    try {
      final result = await client.get(
        path: 'user/$id',
        options: Options(
          headers: <String, dynamic>{'app-id': dotenv.env['APP_ID']},
        ),
      );

      return User.fromJson(result.data as Map<String, dynamic>);
    } on AppException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
