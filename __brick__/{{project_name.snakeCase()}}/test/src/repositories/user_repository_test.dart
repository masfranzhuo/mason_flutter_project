import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/data_sources/user_data_source.dart';
import 'package:{{project_name.snakeCase()}}/src/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../entities/entity_helpers.dart';
import 'user_repository_test.mocks.dart';

@GenerateMocks([UserDataSource])
void main() {
  late UserRepositoryImpl repository;
  late MockUserDataSource mockUserDataSource;

  setUp(() {
    mockUserDataSource = MockUserDataSource();
    repository = UserRepositoryImpl(dataSource: mockUserDataSource);
  });

  group('getUsers', () {
    test('should return UnexpectedFailure(), when throw exception', () async {
      when(mockUserDataSource.getUsers(
        pages: anyNamed('pages'),
        limit: anyNamed('limit'),
      )).thenThrow(Exception());

      final result = await repository.getUsers(pages: 1, limit: 10);

      expect((result as Left).value, isA<UnexpectedFailure>());

      verify(mockUserDataSource.getUsers(pages: 1, limit: 10));
    });

    test('should return UnexpectedFailure(), when throw failure', () async {
      when(mockUserDataSource.getUsers(
        pages: anyNamed('pages'),
        limit: anyNamed('limit'),
      )).thenThrow(const UnexpectedFailure());

      final result = await repository.getUsers(pages: 1, limit: 10);

      expect((result as Left).value, isA<UnexpectedFailure>());

      verify(mockUserDataSource.getUsers(pages: 1, limit: 10));
    });

    test('should return list of users', () async {
      when(mockUserDataSource.getUsers(
        pages: anyNamed('pages'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => users);

      final result = await repository.getUsers(pages: 1, limit: 10);

      expect((result as Right).value, users);

      verify(mockUserDataSource.getUsers(pages: 1, limit: 10));
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
