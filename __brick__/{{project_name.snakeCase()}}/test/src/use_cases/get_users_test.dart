import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/repositories/user_repository.dart';
import 'package:{{project_name.snakeCase()}}/src/use_cases/get_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../entities/entity_helpers.dart';
import 'get_users_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUsers getUsers;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    getUsers = GetUsers(repository: mockUserRepository);
  });

  test('should return UnexpectedFailure, when failed get users', () async {
    when(mockUserRepository.getUsers(
      page: anyNamed('page'),
      limit: anyNamed('limit'),
    )).thenAnswer(
      (_) async => const Left(UnexpectedFailure()),
    );

    final result = await getUsers(page: 1, limit: 10);

    expect((result as Left).value, const UnexpectedFailure());

    verify(mockUserRepository.getUsers(page: 1, limit: 10));
  });

  test('should return NO_DATA_ERROR, when return empty users', () async {
    when(mockUserRepository.getUsers(
      page: anyNamed('page'),
      limit: anyNamed('limit'),
    )).thenAnswer(
      (_) async => const Right([]),
    );

    final result = await getUsers(page: 1, limit: 10);

    expect(
      (result as Left).value,
      const UnexpectedFailure(
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

    final result = await getUsers(page: 1, limit: 10);

    expect((result as Right).value, users);

    verify(mockUserRepository.getUsers(page: 1, limit: 10));
  });
}
