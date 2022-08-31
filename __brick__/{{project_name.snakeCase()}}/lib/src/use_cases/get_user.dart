import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/src/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUser {
  final UserRepository repository;

  GetUser({required this.repository});

  Future<Either<Failure, User>> call({required String id}) async =>
      await repository.getUser(id: id);
}
