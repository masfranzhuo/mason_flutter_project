import 'package:{{project_name.snakeCase()}}/core/services/sqflite.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:injectable/injectable.dart';

abstract class UserLocalDataSource {
  Future<void> setUsers({required List<User> users});
  Future<void> setUser({required User user});
  Future<List<User>> getUsers();
  Future<User> getUser({required String id});
  Future<void> deleteUser({required String id});
  Future<void> deleteAllUser();
}

@LazySingleton(as: UserLocalDataSource)
class UserLocalDataSourceImpl extends UserLocalDataSource {
  final SqfliteService sqfliteService;
  final String _table = 'User';
  final List<String> _column = [
    'id',
    'title',
    'firstName',
    'lastName',
    'picture',
    'gender',
    'email',
    'phone',
    'dateOfBirth',
    'registerDate',
    'location',
  ];

  UserLocalDataSourceImpl({required this.sqfliteService});

  @override
  Future<User> getUser({required String id}) async {
    final result = await sqfliteService.get(
      table: _table,
      id: id,
      columns: _column,
    );

    return User.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<List<User>> getUsers() async {
    final result = await sqfliteService.getList(
      table: _table,
      columns: _column,
    );

    final data = List<dynamic>.from(result ?? []).toList();

    return List<Map<String, dynamic>>.from(data)
        .map((item) => User.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<void> setUser({required User user}) async {
    await sqfliteService.insert(table: _table, map: user.toJson());
    return;
  }

  @override
  Future<void> setUsers({required List<User> users}) async {
    final List<Map<String, dynamic>> maps =
        users.map((e) => e.toJson()).toList();
    await sqfliteService.insertBulk(table: _table, maps: maps);
    return;
  }

  @override
  Future<void> deleteUser({required String id}) async {
    await sqfliteService.delete(table: _table, id: id);
    return;
  }

  @override
  Future<void> deleteAllUser() async {
    await sqfliteService.deleteAll(table: _table);
    return;
  }
}
