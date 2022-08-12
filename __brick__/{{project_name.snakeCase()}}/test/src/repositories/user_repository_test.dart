import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/data_sources/user_data_source.dart';
import 'package:{{project_name.snakeCase()}}/src/data_sources/user_local_data_source.dart';
import 'package:{{project_name.snakeCase()}}/src/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../entities/entity_helpers.dart';
import 'user_repository_test.mocks.dart';

@GenerateMocks([
  UserDataSource,
  UserLocalDataSource,
  // UserSqfliteDataSource,
])
void main() {
  late UserRepositoryImpl repository;
  late MockUserDataSource mockUserDataSource;
  late MockUserLocalDataSource mockUserLocalDataSource;
  // late MockUserSqfliteDataSource mockUserSqfliteDataSource;

  setUp(() {
    mockUserDataSource = MockUserDataSource();
    mockUserLocalDataSource = MockUserLocalDataSource();
    // mockUserSqfliteDataSource = MockUserSqfliteDataSource();
    repository = UserRepositoryImpl(
      dataSource: mockUserDataSource,
      localDataSource: mockUserLocalDataSource,
      // sqfliteDataSource: mockUserSqfliteDataSource,
    );
  });

  group('getUsers', () {
    test('should return UnexpectedFailure(), when throw exception', () async {
      when(mockUserDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(Exception());

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Left).value, isA<UnexpectedFailure>());

      verify(mockUserDataSource.getUsers(page: 1, limit: 10));
    });

    test('should return UnexpectedFailure(), when throw failure', () async {
      when(mockUserDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(const UnexpectedFailure());

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Left).value, isA<UnexpectedFailure>());

      verify(mockUserDataSource.getUsers(page: 1, limit: 10));
    });

    test('should return LocalStorageFailure(), when local data source error',
        () async {
      when(mockUserDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => users);
      when(mockUserLocalDataSource.setUsers(
        users: anyNamed('users'),
      )).thenThrow(const LocalStorageFailure());

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Left).value, isA<LocalStorageFailure>());

      verifyInOrder([
        mockUserDataSource.getUsers(page: 1, limit: 10),
        mockUserLocalDataSource.setUsers(users: users),
      ]);
    });

    test(
        'should return InternetConnectionFailure(), when internet connection error and empty local data source',
        () async {
      when(mockUserDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(const InternetConnectionFailure());
      when(mockUserLocalDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => []);

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Left).value, isA<InternetConnectionFailure>());

      verifyInOrder([
        mockUserDataSource.getUsers(page: 1, limit: 10),
      ]);
    });

    test(
        'should return list of users, when internet connection error and local data source has data',
        () async {
      when(mockUserDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(const InternetConnectionFailure());
      when(mockUserLocalDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => users);

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Right).value, users);

      verifyInOrder([
        mockUserDataSource.getUsers(page: 1, limit: 10),
      ]);
    });

    test('should return list of users', () async {
      when(mockUserDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => users);
      when(mockUserLocalDataSource.setUsers(
        users: anyNamed('users'),
      )).thenAnswer((_) async => unit);

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Right).value, users);

      verifyInOrder([
        mockUserDataSource.getUsers(page: 1, limit: 10),
        mockUserLocalDataSource.setUsers(users: users),
      ]);
    });
  });

  group('getUser', () {
    test('should return UnexpectedFailure(), when throw exception', () async {
      when(mockUserDataSource.getUser(
        id: anyNamed('id'),
      )).thenThrow(Exception());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<UnexpectedFailure>());

      verify(mockUserDataSource.getUser(id: 'anyId'));
    });

    test('should return UnexpectedFailure(), when throw failure', () async {
      when(mockUserDataSource.getUser(
        id: anyNamed('id'),
      )).thenThrow(const UnexpectedFailure());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<UnexpectedFailure>());

      verify(mockUserDataSource.getUser(id: 'anyId'));
    });

    test('should return LocalStorageFailure(), when local data source error',
        () async {
      when(mockUserDataSource.getUser(
        id: anyNamed('id'),
      )).thenAnswer((_) async => user);
      when(mockUserLocalDataSource.setUser(
        user: anyNamed('user'),
      )).thenThrow(const LocalStorageFailure());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<LocalStorageFailure>());

      verifyInOrder([
        mockUserDataSource.getUser(id: 'anyId'),
        mockUserLocalDataSource.setUser(user: user),
      ]);
    });

    test(
        'should return InternetConnectionFailure(), when internet connection error and empty local data source',
        () async {
      when(mockUserDataSource.getUser(
        id: anyNamed('id'),
      )).thenThrow(const InternetConnectionFailure());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<InternetConnectionFailure>());

      verify(mockUserDataSource.getUser(id: 'anyId'));
    });

    test('should return user', () async {
      when(mockUserDataSource.getUser(
        id: anyNamed('id'),
      )).thenAnswer((_) async => user);

      final result = await repository.getUser(id: 'anyId');

      expect((result as Right).value, user);

      verify(mockUserDataSource.getUser(id: 'anyId'));
    });
  });
}
