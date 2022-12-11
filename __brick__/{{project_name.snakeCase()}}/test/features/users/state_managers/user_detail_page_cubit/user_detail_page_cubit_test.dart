import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:{{project_name.snakeCase()}}/features/users/state_managers/user_detail_page_cubit/user_detail_page_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late UserDetailPageCubit cubit;
  late MockGetUser mockGetUser;

  setUp(() {
    mockGetUser = MockGetUser();
    cubit = UserDetailPageCubit(getUser: mockGetUser);
  });

  group('getUser', () {
    blocTest(
      'should emit error, when return app exception',
      build: () {
        when(mockGetUser(any)).thenAnswer(
          (_) async => const Left(AppException()),
        );
        return cubit;
      },
      act: (_) async => cubit.getUser(id: 'anyId'),
      expect: () => [Loading(), Error(e: const AppException())],
      verify: (_) => verify(mockGetUser('anyId')),
    );
    blocTest(
      'should emit loaded, when successfully get user',
      build: () {
        when(mockGetUser(any)).thenAnswer(
          (_) async => Right(user),
        );
        return cubit;
      },
      act: (_) async => cubit.getUser(id: 'anyId'),
      expect: () => [Loading(), Loaded(user: user)],
      verify: (_) => verify(mockGetUser('anyId')),
    );
  });
}
