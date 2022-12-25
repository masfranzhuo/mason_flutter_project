import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:{{project_name.snakeCase()}}/features/users/data_sources/user_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/helpers.dart';

void main() {
  late UserLocalDataSourceImpl localDataSource;
  late MockUserDao mockUserDao;

  setUp(() {
    mockUserDao = MockUserDao();
    localDataSource = UserLocalDataSourceImpl(userDao: mockUserDao);
  });

  group('deleteAllUser', () {
    test('should throw LocalException(), when catch exception', () async {
      when(mockUserDao.deleteAllUsers()).thenThrow(Exception());

      expect(
        () async => await localDataSource.deleteAllUser(),
        throwsA(isA<LocalException>()),
      );

      verify(mockUserDao.deleteAllUsers());
    });

    test('should call deleteAllUser, when delete all user success', () async {
      when(mockUserDao.deleteAllUsers()).thenAnswer((_) async => unit);

      await localDataSource.deleteAllUser();

      verify(mockUserDao.deleteAllUsers());
    });
  });

  group('deleteUser', () {
    test('should throw LocalException(), when catch exception', () async {
      when(mockUserDao.deleteUser(id: anyNamed('id'))).thenThrow(Exception());

      expect(
        () async => await localDataSource.deleteUser(id: 'anyId'),
        throwsA(isA<LocalException>()),
      );

      verify(mockUserDao.deleteUser(id: 'anyId'));
    });

    test('should call deleteUser, when delete user success', () async {
      when(mockUserDao.deleteUser(id: anyNamed('id')))
          .thenAnswer((_) async => unit);

      await localDataSource.deleteUser(id: 'anyId');

      verify(mockUserDao.deleteUser(id: 'anyId'));
    });
  });

  group('getUser', () {
    test('should throw LocalException(), when catch exception', () async {
      when(mockUserDao.selectUser(id: anyNamed('id'))).thenThrow(Exception());

      expect(
        () async => await localDataSource.getUser(id: 'anyId'),
        throwsA(isA<LocalException>()),
      );

      verify(mockUserDao.selectUser(id: 'anyId'));
    });

    test('should return user, when success get user', () async {
      when(mockUserDao.selectUser(id: anyNamed('id')))
          .thenAnswer((_) async => user);

      final result = await localDataSource.getUser(id: 'anyId');

      expect(result, user);

      verify(mockUserDao.selectUser(id: 'anyId'));
    });
  });

  group('getUsers', () {
    test('should throw LocalException(), when catch exception', () async {
      when(mockUserDao.selectUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(Exception());

      expect(
        () async => await localDataSource.getUsers(),
        throwsA(isA<LocalException>()),
      );

      verify(mockUserDao.selectUsers(page: 1, limit: PaginationConfig.limit));
    });

    test('should return users, when success get users', () async {
      when(mockUserDao.selectUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => users);

      final result = await localDataSource.getUsers();
      expect(result, users);

      verify(mockUserDao.selectUsers(page: 1, limit: PaginationConfig.limit));
    });
  });

  group('addUser', () {
    test('should throw LocalException(), when catch exception', () async {
      when(mockUserDao.insertUser(user: anyNamed('user')))
          .thenThrow(Exception());

      expect(
        () async => await localDataSource.addUser(user: user),
        throwsA(isA<LocalException>()),
      );

      verify(mockUserDao.insertUser(user: user));
    });

    test('should call insertUser, when success add user', () async {
      when(mockUserDao.insertUser(user: anyNamed('user')))
          .thenAnswer((_) async => unit);

      await localDataSource.addUser(user: user);

      verify(mockUserDao.insertUser(user: user));
    });
  });

  group('addUsers', () {
    test('should throw LocalException(), when catch exception', () async {
      when(mockUserDao.insertUsers(users: anyNamed('users')))
          .thenThrow(Exception());

      expect(
        () async => await localDataSource.addUsers(users: users),
        throwsA(isA<LocalException>()),
      );

      verify(mockUserDao.insertUsers(users: users));
    });

    test('should call insertUser, when success add users', () async {
      when(mockUserDao.insertUsers(users: anyNamed('users')))
          .thenAnswer((_) async => unit);

      await localDataSource.addUsers(users: users);

      verify(mockUserDao.insertUsers(users: users));
    });
  });
}
