import 'package:drift/drift.dart';
import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/features/users/database/database.dart';
import 'package:{{project_name.snakeCase()}}/features/users/database/schemas/user_isar.dart';
import 'package:{{project_name.snakeCase()}}/features/users/models/user.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

abstract class UserDao {
  Future<void> insertUsers({required List<User> users});
  Future<void> insertUser({required User user});
  Future<List<User>> selectUsers({
    int? page = 1,
    int limit = PaginationConfig.limit,
  });
  Future<User> selectUser({required String id});
  Future<void> deleteUser({required String id});
  Future<void> deleteAllUsers();
}

@Named('isar')
@LazySingleton(as: UserDao)
class UserDaoImpl implements UserDao {
  final Isar isar;

  UserDaoImpl(this.isar);

  @override
  Future<void> deleteAllUsers() async {
    await isar.writeTxn(() async {
      final idStrings =
          await isar.userIsars.where().idStringProperty().findAll();

      await isar.userIsars.deleteAllByIdString(idStrings);
    });
  }

  @override
  Future<void> deleteUser({required String id}) async {
    await isar.writeTxn(() async {
      await isar.userIsars.deleteByIdString(id);
    });
  }

  @override
  Future<void> insertUser({required User user}) async {
    final userIsar = UserIsar.fromJson(user.toJson());

    await isar.writeTxn(() async {
      await isar.userIsars.putByIdString(userIsar);
    });
  }

  @override
  Future<void> insertUsers({required List<User> users}) async {
    await isar.writeTxn(() async {
      final List<UserIsar> usersIsar = [];
      for (User user in users) {
        final userIsar = UserIsar.fromJson(user.toJson());
        usersIsar.add(userIsar);
      }

      await isar.userIsars.putAllByIdString(usersIsar);
    });
  }

  @override
  Future<User> selectUser({required String id}) async {
    final userIsar = await isar.userIsars.getByIdString(id);

    final user = User.fromJson(userIsar!.toJson());

    return user;
  }

  @override
  Future<List<User>> selectUsers({
    int? page = 1,
    int limit = PaginationConfig.limit,
  }) async {
    final query = isar.userIsars.where();
    if (page != null) {
      final offset = (limit * page) - limit;
      query.offset(offset).limit(limit);
    }
    final userIsars = await query.findAll();

    final List<User> users = [];
    for (UserIsar userIsar in userIsars) {
      final user = User.fromJson(userIsar.toJson());
      users.add(user);
    }

    return users;
  }
}

@Named('drift')
@LazySingleton(as: UserDao)
class UserDaoImpl2 extends Database implements UserDao {
  @override
  Future<void> deleteAllUsers() async {
    await delete(userDrift).go();
  }

  @override
  Future<void> deleteUser({required String id}) async {
    await (delete(userDrift)..where((e) => e.id.equals(id))).go();
  }

  @override
  Future<void> insertUser({required User user}) async {
    final data = UserDriftData.fromJson(user.toJson());
    await into(userDrift).insert(data, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> insertUsers({required List<User> users}) async {
    final data = users.map((e) => UserDriftData.fromJson(e.toJson()));
    await batch((batch) {
      batch.insertAll(
        userDrift,
        data,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<User> selectUser({required String id}) async {
    final data =
        await (select(userDrift)..where((e) => e.id.equals(id))).getSingle();
    return User.fromJson(data.toJson());
  }

  @override
  Future<List<User>> selectUsers({
    int? page = 1,
    int limit = PaginationConfig.limit,
  }) async {
    final query = select(userDrift);

    if (page != null) {
      final offset = (limit * page) - limit;
      query.limit(limit, offset: offset);
    }
    final data = await query.get();

    return data.map((e) => User.fromJson(e.toJson())).toList();
  }
}
