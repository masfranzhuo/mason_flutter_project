import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:{{project_name.snakeCase()}}/core/base/usecase/usecase.dart';
import 'package:{{project_name.snakeCase()}}/features/users/models/user.dart';
import 'package:{{project_name.snakeCase()}}/features/users/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUser extends BaseUsecase<User, String> {
  final UserRepository repository;

  GetUser({required this.repository});

  @override
  Future<Either<AppException, User>> call(String params) async =>
      await repository.getUser(id: params);
}
