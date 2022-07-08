import 'package:dartz/dartz.dart';
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

  test('should return list of users', () async {
    when(mockUserRepository.getUsers(
      pages: anyNamed('pages'),
      limit: anyNamed('limit'),
    )).thenAnswer(
      (_) async => Right(users),
    );

    final result = await getUsers(const Params(pages: 1, limit: 10));

    expect((result as Right).value, users);

    verify(mockUserRepository.getUsers(pages: 1, limit: 10));
  });
}
