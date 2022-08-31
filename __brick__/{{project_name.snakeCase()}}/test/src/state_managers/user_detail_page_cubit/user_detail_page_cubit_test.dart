import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/state_managers/user_detail_page_cubit/user_detail_page_cubit.dart';
import 'package:{{project_name.snakeCase()}}/src/use_cases/get_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/entity_helpers.dart';
import 'user_detail_page_cubit_test.mocks.dart';

@GenerateMocks([GetUser])
void main() {
  late UserDetailPageCubit cubit;
  late MockGetUser mockGetUser;

  setUp(() {
    mockGetUser = MockGetUser();
    cubit = UserDetailPageCubit(getUser: mockGetUser);
  });

  group('getUser', () {
    blocTest(
      'should emit error, when return failure',
      build: () {
        when(mockGetUser(id: anyNamed('id'))).thenAnswer(
          (_) async => const Left(UnexpectedFailure()),
        );
        return cubit;
      },
      act: (_) async => cubit.getUser(id: 'anyId'),
      expect: () => [Loading(), Error(failure: const UnexpectedFailure())],
      verify: (_) => verify(mockGetUser(id: anyNamed('id'))),
    );
    blocTest(
      'should emit loaded, when successfully get user',
      build: () {
        when(mockGetUser(id: anyNamed('id'))).thenAnswer(
          (_) async => Right(user),
        );
        return cubit;
      },
      act: (_) async => cubit.getUser(id: 'anyId'),
      expect: () => [Loading(), Loaded(user: user)],
      verify: (_) => verify(mockGetUser(id: anyNamed('id'))),
    );
  });
}
