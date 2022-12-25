import 'package:{{project_name.snakeCase()}}/core/base/data_source/data_source.dart';
import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:{{project_name.snakeCase()}}/features/users/database/dao/user_dao.dart';
import 'package:{{project_name.snakeCase()}}/features/users/models/user.dart';
import 'package:injectable/injectable.dart';

abstract class UserLocalDataSource extends BaseDataSource {
  Future<void> addUsers({required List<User> users});
  Future<void> addUser({required User user});
  Future<List<User>> getUsers({
    int? page = 1,
    int limit = PaginationConfig.limit,
  });
  Future<User> getUser({required String id});
  Future<void> deleteUser({required String id});
  Future<void> deleteAllUser();
}

@LazySingleton(as: UserLocalDataSource)
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final UserDao userDao;

  UserLocalDataSourceImpl({@Named('drift') required this.userDao});

  @override
  Future<void> deleteAllUser() async {
    try {
      await userDao.deleteAllUsers();
    } on Exception catch (e) {
      throw LocalException(message: e.toString());
    }
  }

  @override
  Future<void> deleteUser({required String id}) async {
    try {
      await userDao.deleteUser(id: id);
    } on Exception catch (e) {
      throw LocalException(message: e.toString());
    }
  }

  @override
  Future<User> getUser({required String id}) async {
    try {
      return await userDao.selectUser(id: id);
    } on Exception catch (e) {
      throw LocalException(message: e.toString());
    }
  }

  @override
  Future<List<User>> getUsers({
    int? page = 1,
    int limit = PaginationConfig.limit,
  }) async {
    try {
      return userDao.selectUsers(page: page, limit: limit);
    } on Exception catch (e) {
      throw LocalException(message: e.toString());
    }
  }

  @override
  Future<void> addUser({required User user}) async {
    try {
      await userDao.insertUser(user: user);
    } on Exception catch (e) {
      throw LocalException(message: e.toString());
    }
  }

  @override
  Future<void> addUsers({required List<User> users}) async {
    try {
      await userDao.insertUsers(users: users);
    } on Exception catch (e) {
      throw LocalException(message: e.toString());
    }
  }
}
