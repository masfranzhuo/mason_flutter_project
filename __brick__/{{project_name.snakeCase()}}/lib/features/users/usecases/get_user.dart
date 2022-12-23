import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/base/exception/exception.dart';
import 'package:flutter_project/core/base/usecase/usecase.dart';
import 'package:flutter_project/features/users/models/user.dart';
import 'package:flutter_project/features/users/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUser extends AppUsecase<User, String> {
  final UserRepository repository;

  GetUser({required this.repository});

  @override
  Future<Either<AppException, User>> call(String params) async =>
      await repository.getUser(id: params);
}
