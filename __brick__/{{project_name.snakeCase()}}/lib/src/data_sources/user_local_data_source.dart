import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/location_isar.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user_isar.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

abstract class UserLocalDataSource {
  Future<void> setUsers({required List<User> users});
  Future<void> setUser({required User user});
  Future<List<User>> getUsers({int? page, int limit = PaginationConfig.limit});
  Future<User> getUser({required String id});
  Future<void> deleteUser({required String id});
  Future<void> deleteAllUser();
}

@LazySingleton(as: UserLocalDataSource)
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Isar isar;

  UserLocalDataSourceImpl({required this.isar});

  @override
  Future<void> deleteAllUser() async {
    try {
      await isar.writeTxn(() async {
        final idStrings =
            await isar.userIsars.where().idStringProperty().findAll();

        await isar.userIsars.deleteAllByIdString(idStrings);
        await isar.locationIsars.deleteAllByIdString(idStrings);
      });
      return;
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteUser({required String id}) async {
    try {
      await isar.writeTxn(() async {
        await isar.userIsars.deleteByIdString(id);
        await isar.locationIsars.deleteByIdString(id);
      });
      return;
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }

  @override
  Future<User> getUser({required String id}) async {
    try {
      final userIsar = await isar.userIsars.getByIdString(id);
      await userIsar?.location.load();

      final user = userIsar!.toUser();

      return user;
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }

  @override
  Future<List<User>> getUsers(
      {int? page, int limit = PaginationConfig.limit}) async {
    try {
      final query = isar.userIsars.where();
      if (page != null) {
        final offset = (limit * page) - limit;
        query.offset(offset).limit(limit);
      }
      final userIsars = await query.findAll();

      final List<User> users = [];
      for (UserIsar userIsar in userIsars) {
        final user = userIsar.toUser();
        users.add(user);
      }

      return users;
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }

  @override
  Future<void> setUser({required User user}) async {
    try {
      final userIsar = UserIsar.fromUser(user);

      await isar.writeTxn(() async {
        await isar.userIsars.putByIdString(userIsar);
        await isar.locationIsars.put(userIsar.location.value!);
        await userIsar.location.save();
      });
      return;
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }

  @override
  Future<void> setUsers({required List<User> users}) async {
    try {
      await isar.writeTxn(() async {
        for (User user in users) {
          final userIsar = UserIsar.fromUser(user);
          await isar.userIsars.putByIdString(userIsar);
        }
      });
      return;
    } on Exception catch (e) {
      throw LocalStorageFailure(message: e.toString());
    }
  }
}
