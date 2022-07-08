import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/services/http_client.dart';
import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:injectable/injectable.dart';

abstract class UserDataSource {
  Future<List<User>> getUsers({
    required int pages,
    int limit = Pagination.limit,
  });
  Future<User> getUser({required String id});
}

@LazySingleton(as: UserDataSource)
class UserDataSourceImpl extends UserDataSource {
  final HttpClientService client;

  UserDataSourceImpl({required this.client});

  @override
  Future<List<User>> getUsers({
    required int pages,
    int limit = Pagination.limit,
  }) async {
    try {
      final result = await client.get(
        path: 'user',
        queryParameters: {'limit': limit, 'page': pages},
      );

      final data = List<dynamic>.from(result.data['data'] ?? []).toList();

      return List<Map<String, dynamic>>.from(data)
          .map((item) => User.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on Exception catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  @override
  Future<User> getUser({required String id}) async {
    try {
      final result = await client.get(path: 'user/$id');

      return User.fromJson(result.data as Map<String, dynamic>);
    } on Exception catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }
}
