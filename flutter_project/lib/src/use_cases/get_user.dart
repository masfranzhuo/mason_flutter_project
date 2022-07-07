import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/utils/failure.dart';
import 'package:flutter_project/core/utils/use_case.dart';
import 'package:flutter_project/src/entities/user.dart';
import 'package:flutter_project/src/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUser extends UseCase<User, String> {
  final UserRepository repository;

  GetUser({required this.repository});

  @override
  Future<Either<Failure, User>> call(String params) async {
    return repository.getUser(id: params);
  }
}
