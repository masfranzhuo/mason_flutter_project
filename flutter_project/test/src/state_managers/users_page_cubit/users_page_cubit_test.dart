import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/utils/failure.dart';
import 'package:flutter_project/src/entities/user.dart';
import 'package:flutter_project/src/state_managers/users_page_cubit/users_page_cubit.dart';
import 'package:flutter_project/src/use_cases/get_users.dart';
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
      'should emit failure, when return error',
      build: () {
        when(mockGetUsers(any)).thenAnswer(
          (_) async => const Left(UnexpectedFailure()),
        );
        return cubit;
      },
      act: (_) async => cubit.getUsers(),
      expect: () => [
        UsersPageState(isLoading: true),
        UsersPageState(
          isLoading: false,
          failure: const UnexpectedFailure(),
        ),
      ],
      verify: (_) async {
        verify(mockGetUsers(any));
      },
    );
    blocTest(
      'should emit failure code = NO_DATA_FAILURE, when return empty users',
      build: () {
        when(mockGetUsers(any)).thenAnswer(
          (_) async => const Right(<User>[]),
        );
        return cubit;
      },
      act: (_) async => cubit.getUsers(),
      expect: () => [
        UsersPageState(isLoading: true),
        UsersPageState(
          isLoading: false,
          failure: const UnexpectedFailure(
            code: 'NO_DATA_FAILURE',
            message: 'No more data available',
          ),
        ),
      ],
      verify: (_) async {
        verify(mockGetUsers(any));
      },
    );
    blocTest(
      'should emit users and pages = 1, when get users for the first time',
      build: () {
        when(mockGetUsers(any)).thenAnswer(
          (_) async => Right(users),
        );
        return cubit;
      },
      act: (_) async => cubit.getUsers(),
      expect: () => [
        UsersPageState(isLoading: true),
        UsersPageState(
          isLoading: false,
          pages: 1,
          users: users,
        ),
      ],
      verify: (_) async {
        verify(mockGetUsers(any));
      },
    );
    blocTest(
      'should emit users and pages = 2, when load more users',
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
        UsersPageState(
          isLoading: false,
          pages: 2,
          users: [...users, ...users],
        ),
      ],
      verify: (_) async {
        verify(mockGetUsers(any)).called(2);
      },
    );
    blocTest(
      'should emit users and pages = 1, when isReload is true',
      build: () {
        when(mockGetUsers(any)).thenAnswer(
          (_) async => Right(users),
        );
        return cubit;
      },
      act: (_) async => cubit.getUsers(isReload: true),
      seed: () => UsersPageState(
        isLoading: false,
        pages: 1,
        users: users,
      ),
      expect: () => [
        UsersPageState(isLoading: true),
        UsersPageState(
          isLoading: false,
          pages: 1,
          users: users,
        ),
      ],
      verify: (_) async {
        verify(mockGetUsers(any));
      },
    );
  });
}
