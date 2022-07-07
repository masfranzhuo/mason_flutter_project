import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/utils/failure.dart';
import 'package:flutter_project/src/state_managers/user_detail_page_cubit/user_detail_page_cubit.dart';
import 'package:flutter_project/src/use_cases/get_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../../entities/entity_helpers.dart';
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
      'should emit failure, when return error',
      build: () {
        when(mockGetUser(any)).thenAnswer(
          (_) async => const Left(UnexpectedFailure()),
        );
        return cubit;
      },
      act: (_) async => cubit.getUser(id: 'anyId'),
      expect: () => [
        UserDetailPageState(isLoading: true),
        UserDetailPageState(
          isLoading: false,
          failure: const UnexpectedFailure(),
        ),
      ],
      verify: (_) async {
        verify(mockGetUser(any));
      },
    );
    blocTest(
      'should emit user, when successfully get user',
      build: () {
        when(mockGetUser(any)).thenAnswer(
          (_) async => Right(user),
        );
        return cubit;
      },
      act: (_) async => cubit.getUser(id: 'anyId'),
      expect: () => [
        UserDetailPageState(isLoading: true),
        UserDetailPageState(isLoading: false, user: user),
      ],
      verify: (_) async {
        verify(mockGetUser(any));
      },
    );
  });
}
