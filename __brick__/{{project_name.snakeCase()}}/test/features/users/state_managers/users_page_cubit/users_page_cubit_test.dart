import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:{{project_name.snakeCase()}}/features/users/state_managers/users_page_cubit/users_page_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late UsersPageCubit cubit;
  late MockGetUsers mockGetUsers;

  setUp(() {
    mockGetUsers = MockGetUsers();
    cubit = UsersPageCubit(getUsers: mockGetUsers);
  });

  group('getUsers', () {
    blocTest(
      'should emit error, when return app exception',
      build: () {
        when(mockGetUsers(any)).thenAnswer(
          (_) async => const Left(AppException()),
        );
        return cubit;
      },
      act: (_) async => cubit.getUsers(),
      expect: () => [
        Loading(),
        Error(e: const AppException()),
      ],
      verify: (_) async {
        verify(mockGetUsers(any));
      },
    );
    blocTest(
      'should emit loaded users and page = 1, when get users for the first time',
      build: () {
        when(mockGetUsers(any)).thenAnswer(
          (_) async => Right(users),
        );
        return cubit;
      },
      act: (_) async => cubit.getUsers(),
      expect: () => [
        Loading(),
        Loaded(page: 1, users: users),
      ],
      verify: (_) async {
        verify(mockGetUsers(any));
      },
    );
    blocTest(
      'should emit loaded users and page = 2, when load more users',
      build: () {
        when(mockGetUsers(any)).thenAnswer(
          (_) async => Right(users),
        );
        return cubit;
      },
      act: (_) async => cubit
        ..getUsers()
        ..getUsers(),
      skip: 2,
      expect: () => [
        Loaded(page: 2, users: [...users, ...users]),
      ],
      verify: (_) async {
        verify(mockGetUsers(any)).called(2);
      },
    );
    blocTest(
      'should emit loaded users and page = 1, when isReload is true',
      build: () {
        when(mockGetUsers(any)).thenAnswer(
          (_) async => Right(users),
        );
        return cubit;
      },
      act: (_) async => cubit.getUsers(isReload: true),
      seed: () => UsersPageState.loaded(page: 1, users: users),
      expect: () => [
        Loading(),
        Loaded(page: 1, users: users),
      ],
      verify: (_) async {
        verify(mockGetUsers(any));
      },
    );
  });
}
