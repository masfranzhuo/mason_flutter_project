import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/state_managers/users_page_cubit/users_page_cubit.dart';
import 'package:{{project_name.snakeCase()}}/src/use_cases/get_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../../entities/entity_helpers.dart';
import 'users_page_cubit_test.mocks.dart';

@GenerateMocks([GetUsers])
void main() {
  late UsersPageCubit cubit;
  late MockGetUsers mockGetUsers;

  setUp(() {
    mockGetUsers = MockGetUsers();
    cubit = UsersPageCubit(getUsers: mockGetUsers);
  });

  group('getUsers', () {
    blocTest(
      'should emit error, when return failure',
      build: () {
        when(mockGetUsers(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        )).thenAnswer(
          (_) async => const Left(UnexpectedFailure()),
        );
        return cubit;
      },
      act: (_) async => cubit.getUsers(),
      expect: () => [
        Loading(),
        Error(failure: const UnexpectedFailure()),
      ],
      verify: (_) async {
        verify(mockGetUsers(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        ));
      },
    );
    blocTest(
      'should emit loaded users and page = 1, when get users for the first time',
      build: () {
        when(mockGetUsers(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        )).thenAnswer(
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
        verify(mockGetUsers(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        ));
      },
    );
    blocTest(
      'should emit loaded users and page = 2, when load more users',
      build: () {
        when(mockGetUsers(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        )).thenAnswer(
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
        verify(mockGetUsers(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        )).called(2);
      },
    );
    blocTest(
      'should emit loaded users and page = 1, when isReload is true',
      build: () {
        when(mockGetUsers(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        )).thenAnswer(
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
        verify(mockGetUsers(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        ));
      },
    );
  });
}
