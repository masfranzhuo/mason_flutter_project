import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/services/internet_connection.dart';
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
  InternetConnectionService,
  UserDataSource,
  UserLocalDataSource,
  // UserSqfliteDataSource,
])
void main() {
  late UserRepositoryImpl repository;
  late MockInternetConnectionService mockInternetConnectionService;
  late MockUserDataSource mockUserDataSource;
  late MockUserLocalDataSource mockUserLocalDataSource;
  // late MockUserSqfliteDataSource mockUserSqfliteDataSource;

  setUp(() {
    mockInternetConnectionService = MockInternetConnectionService();
    mockUserDataSource = MockUserDataSource();
    mockUserLocalDataSource = MockUserLocalDataSource();
    // mockUserSqfliteDataSource = MockUserSqfliteDataSource();
    repository = UserRepositoryImpl(
      internetConnectionService: mockInternetConnectionService,
      dataSource: mockUserDataSource,
      localDataSource: mockUserLocalDataSource,
      // sqfliteDataSource: mockUserSqfliteDataSource,
    );
  });

  group('getUsers', () {
    test('should return UnexpectedFailure(), when catch exception', () async {
      when(mockInternetConnectionService.checkConnection())
          .thenAnswer((_) async => unit);
      when(mockUserDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(Exception());

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Left).value, isA<UnexpectedFailure>());

      verifyInOrder([
        mockInternetConnectionService.checkConnection(),
        mockUserDataSource.getUsers(page: 1, limit: 10),
      ]);
    });

    test('should return UnexpectedFailure(), when catch failure', () async {
      when(mockInternetConnectionService.checkConnection())
          .thenAnswer((_) async => unit);
      when(mockUserDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(const UnexpectedFailure());

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Left).value, isA<UnexpectedFailure>());

      verifyInOrder([
        mockInternetConnectionService.checkConnection(),
        mockUserDataSource.getUsers(page: 1, limit: 10),
      ]);
    });

    test(
        'should return LocalStorageFailure(), when catch local data source error',
        () async {
      when(mockInternetConnectionService.checkConnection())
          .thenAnswer((_) async => unit);
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
        mockInternetConnectionService.checkConnection(),
        mockUserDataSource.getUsers(page: 1, limit: 10),
        mockUserLocalDataSource.setUsers(users: users),
      ]);
    });

    test(
        'should return InternetConnectionFailure(), when catch internet connection error and empty local data source',
        () async {
      when(mockInternetConnectionService.checkConnection())
          .thenThrow(const InternetConnectionFailure());
      when(mockUserLocalDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => []);

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Left).value, isA<InternetConnectionFailure>());

      verifyInOrder([
        mockInternetConnectionService.checkConnection(),
      ]);
    });

    test(
        'should return list of users, when catch internet connection error and local data source has data',
        () async {
      when(mockInternetConnectionService.checkConnection())
          .thenThrow(const InternetConnectionFailure());
      when(mockUserLocalDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => users);

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Right).value, users);

      verifyInOrder([
        mockInternetConnectionService.checkConnection(),
      ]);
    });

    test('should return list of users', () async {
      when(mockInternetConnectionService.checkConnection())
          .thenAnswer((_) async => unit);
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
        mockInternetConnectionService.checkConnection(),
        mockUserDataSource.getUsers(page: 1, limit: 10),
        mockUserLocalDataSource.setUsers(users: users),
      ]);
    });
  });

  group('getUser', () {
    test('should return UnexpectedFailure(), when catch exception', () async {
      when(mockInternetConnectionService.checkConnection())
          .thenAnswer((_) async => unit);
      when(mockUserDataSource.getUser(
        id: anyNamed('id'),
      )).thenThrow(Exception());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<UnexpectedFailure>());

      verifyInOrder([
        mockInternetConnectionService.checkConnection(),
        mockUserDataSource.getUser(id: 'anyId'),
      ]);
    });

    test('should return UnexpectedFailure(), when catch failure', () async {
      when(mockInternetConnectionService.checkConnection())
          .thenAnswer((_) async => unit);
      when(mockUserDataSource.getUser(
        id: anyNamed('id'),
      )).thenThrow(const UnexpectedFailure());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<UnexpectedFailure>());

      verifyInOrder([
        mockInternetConnectionService.checkConnection(),
        mockUserDataSource.getUser(id: 'anyId'),
      ]);
    });

    test(
        'should return LocalStorageFailure(), when catch local data source error',
        () async {
      when(mockInternetConnectionService.checkConnection())
          .thenAnswer((_) async => unit);
      when(mockUserDataSource.getUser(
        id: anyNamed('id'),
      )).thenAnswer((_) async => user);
      when(mockUserLocalDataSource.setUser(
        user: anyNamed('user'),
      )).thenThrow(const LocalStorageFailure());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<LocalStorageFailure>());

      verifyInOrder([
        mockInternetConnectionService.checkConnection(),
        mockUserDataSource.getUser(id: 'anyId'),
        mockUserLocalDataSource.setUser(user: user),
      ]);
    });

    test(
        'should return InternetConnectionFailure(), when catch internet connection error and empty local data source',
        () async {
      when(mockInternetConnectionService.checkConnection())
          .thenThrow(const InternetConnectionFailure());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<InternetConnectionFailure>());

      verify(mockInternetConnectionService.checkConnection());
    });

    test('should return user', () async {
      when(mockUserDataSource.getUser(
        id: anyNamed('id'),
      )).thenAnswer((_) async => user);
      when(mockUserLocalDataSource.setUser(
        user: anyNamed('user'),
      )).thenAnswer((_) async => user);

      final result = await repository.getUser(id: 'anyId');

      expect((result as Right).value, user);

      verifyInOrder([
        mockInternetConnectionService.checkConnection(),
        mockUserDataSource.getUser(id: 'anyId'),
        mockUserLocalDataSource.setUser(user: user)
      ]);
    });
  });
}
