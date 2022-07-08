import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/src/repositories/user_repository.dart';
import 'package:{{project_name.snakeCase()}}/src/use_cases/get_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../entities/entity_helpers.dart';
import 'get_user_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUser getUser;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    getUser = GetUser(repository: mockUserRepository);
  });

  test('should return user', () async {
    when(mockUserRepository.getUser(
      id: anyNamed('id'),
    )).thenAnswer(
      (_) async => Right(user),
    );

    final result = await getUser('anyId');

    expect((result as Right).value, user);

    verify(mockUserRepository.getUser(id: 'anyId'));
  });
}
