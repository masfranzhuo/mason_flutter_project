import 'dart:convert';

import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/core/services/sqflite.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:injectable/injectable.dart';

abstract class UserSqfliteDataSource {
  Future<void> setUsers({required List<User> users});
  Future<void> setUser({required User user});
  Future<List<User>> getUsers({int? page, int limit = PaginationConfig.limit});
  Future<User> getUser({required String id});
  Future<void> deleteUser({required String id});
  Future<void> deleteAllUser();
}

@LazySingleton(as: UserSqfliteDataSource)
class UserSqfliteDataSourceImpl implements UserSqfliteDataSource {
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

    /// [https://github.com/tekartik/sqflite/blob/master/sqflite/doc/supported_types.md#supported-types]
    /// there are 2 solutions working with nested model:
    /// 1. flattened solution could make the properties queried,
    /// but need to create another proper model
    /// 2.  encoded nested maps and lists as json, declaring the column as a [String] solution,
    /// could not be queried, but does not need create another model,
    /// just need to tweak some code manually when save or get the nested model
    ///
  ];

  UserSqfliteDataSourceImpl({required this.sqfliteService});

  @override
  Future<User> getUser({required String id}) async {
    try {
      final result = await sqfliteService.get(
        table: _table,
        id: id,
        columns: _column,
      );

      /// usually database return immutable/unmodifiable data, so you have to clone it before changing
      ///
      final map = Map.of(result as Map<String, dynamic>);
      if (map['location'] != null) {
        /// decode for nested model and replace in map
        ///
        map['location'] = jsonDecode(map['location']);
      }

      return User.fromJson(map);
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }

  @override
  Future<List<User>> getUsers(
      {int? page, int limit = PaginationConfig.limit}) async {
    try {
      int? offset;
      if (page != null) {
        offset = (limit * page) - limit;
      }

      final result = await sqfliteService.getList(
        table: _table,
        columns: _column,
        limit: limit,
        offset: offset,
      );

      return (result ?? [])
          .map((item) => User.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }

  @override
  Future<void> setUser({required User user}) async {
    try {
      final map = user.toJson();
      if (user.location != null) {
        /// encode to proper string before save to sqflite
        ///
        map['location'] = jsonEncode(user.location?.toJson());
      }

      await sqfliteService.insert(table: _table, map: map);
      return;
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }

  @override
  Future<void> setUsers({required List<User> users}) async {
    try {
      final List<Map<String, dynamic>> maps =
          users.map((e) => e.toJson()).toList();
      await sqfliteService.insertBulk(table: _table, maps: maps);
      return;
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteUser({required String id}) async {
    try {
      await sqfliteService.delete(table: _table, id: id);
      return;
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteAllUser() async {
    try {
      await sqfliteService.deleteAll(table: _table);
      return;
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }
}
