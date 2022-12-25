import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:{{project_name.snakeCase()}}/features/users/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/helpers.dart';

void main() {
  late UserRepositoryImpl repository;
  late MockUserNetworkDataSource mockUserNetworkDataSource;
  late MockUserLocalDataSource mockUserLocalDataSource;

  setUp(() {
    mockUserNetworkDataSource = MockUserNetworkDataSource();
    mockUserLocalDataSource = MockUserLocalDataSource();
    repository = UserRepositoryImpl(
      networkDataSource: mockUserNetworkDataSource,
      localDataSource: mockUserLocalDataSource,
    );
  });

  group('getUsers', () {
    test('should return AppException(), when catch exception', () async {
      when(mockUserNetworkDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(Exception());

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Left).value, isA<AppException>());

      verify(mockUserNetworkDataSource.getUsers(page: 1, limit: 10));
    });

    test('should return AppException(), when catch app exception', () async {
      when(mockUserNetworkDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(const AppException());

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Left).value, isA<AppException>());

      verify(mockUserNetworkDataSource.getUsers(page: 1, limit: 10));
    });

    test(
        'should return InternetConnectionException(), when catch internet connection error and empty local data source',
        () async {
      when(mockUserNetworkDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(const InternetConnectionException());
      when(mockUserLocalDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => []);

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Left).value, isA<InternetConnectionException>());

      verifyInOrder([
        mockUserNetworkDataSource.getUsers(page: 1, limit: 10),
        mockUserLocalDataSource.getUsers(page: 2, limit: 10),
      ]);
    });

    test(
        'should return list of users, when catch internet connection error and local data source has data',
        () async {
      when(mockUserNetworkDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(const InternetConnectionException());
      when(mockUserLocalDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => users);

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Right).value, users);

      verifyInOrder([
        mockUserNetworkDataSource.getUsers(page: 1, limit: 10),
        mockUserLocalDataSource.getUsers(page: 2, limit: 10),
      ]);
    });

    test('should return list of users', () async {
      when(mockUserNetworkDataSource.getUsers(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => users);
      when(mockUserLocalDataSource.addUsers(
        users: anyNamed('users'),
      )).thenAnswer((_) async => unit);

      final result = await repository.getUsers(page: 1, limit: 10);

      expect((result as Right).value, users);

      verifyInOrder([
        mockUserNetworkDataSource.getUsers(page: 1, limit: 10),
        mockUserLocalDataSource.addUsers(users: users),
      ]);
    });
  });

  group('getUser', () {
    test('should return AppException(), when catch exception', () async {
      when(mockUserNetworkDataSource.getUser(
        id: anyNamed('id'),
      )).thenThrow(Exception());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<AppException>());

      verify(mockUserNetworkDataSource.getUser(id: 'anyId'));
    });

    test('should return AppException(), when catch app exception', () async {
      when(mockUserNetworkDataSource.getUser(
        id: anyNamed('id'),
      )).thenThrow(const AppException());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<AppException>());

      verify(mockUserNetworkDataSource.getUser(id: 'anyId'));
    });

    test(
        'should return InternetConnectionException(), when catch internet connection error and empty local data source',
        () async {
      when(mockUserNetworkDataSource.getUser(
        id: anyNamed('id'),
      )).thenThrow(const InternetConnectionException());

      final result = await repository.getUser(id: 'anyId');

      expect((result as Left).value, isA<InternetConnectionException>());

      verify(mockUserNetworkDataSource.getUser(id: 'anyId'));
    });

    test('should return user', () async {
      when(mockUserNetworkDataSource.getUser(
        id: anyNamed('id'),
      )).thenAnswer((_) async => user);
      when(mockUserLocalDataSource.addUser(
        user: anyNamed('user'),
      )).thenAnswer((_) async => user);

      final result = await repository.getUser(id: 'anyId');

      expect((result as Right).value, user);

      verifyInOrder([
        mockUserNetworkDataSource.getUser(id: 'anyId'),
        mockUserLocalDataSource.addUser(user: user)
      ]);
    });
  });
}
