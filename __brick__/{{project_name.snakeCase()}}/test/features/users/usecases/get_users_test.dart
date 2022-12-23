import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/base/exception/exception.dart';
import 'package:flutter_project/features/users/usecases/get_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/helpers.dart';

void main() {
  late GetUsers getUsers;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    getUsers = GetUsers(repository: mockUserRepository);
  });

  test('should return AppException, when failed get users', () async {
    when(mockUserRepository.getUsers(
      page: anyNamed('page'),
      limit: anyNamed('limit'),
    )).thenAnswer(
      (_) async => const Left(AppException()),
    );

    final result = await getUsers(getUsersParams);

    expect((result as Left).value, const AppException());

    verify(mockUserRepository.getUsers(page: 1, limit: 10));
  });

  test('should return NO_DATA_ERROR, when return empty users', () async {
    when(mockUserRepository.getUsers(
      page: anyNamed('page'),
      limit: anyNamed('limit'),
    )).thenAnswer(
      (_) async => const Right([]),
    );

    final result = await getUsers(getUsersParams);

    expect(
      (result as Left).value,
      const AppException(
        code: 'NO_DATA_ERROR',
        message: 'No more data available',
      ),
    );

    verify(mockUserRepository.getUsers(page: 1, limit: 10));
  });

  test('should return list of users, when successfully get users', () async {
    when(mockUserRepository.getUsers(
      page: anyNamed('page'),
      limit: anyNamed('limit'),
    )).thenAnswer(
      (_) async => Right(users),
    );

    final result = await getUsers(getUsersParams);

    expect((result as Right).value, users);

    verify(mockUserRepository.getUsers(page: 1, limit: 10));
  });
}
