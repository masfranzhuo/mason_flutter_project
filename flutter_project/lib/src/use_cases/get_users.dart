import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/utils/failure.dart';
import 'package:flutter_project/core/utils/use_case.dart';
import 'package:flutter_project/core/config/general_config.dart';
import 'package:flutter_project/src/entities/user.dart';
import 'package:flutter_project/src/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUsers extends UseCase<List<User>, Params> {
  final UserRepository repository;

  GetUsers({required this.repository});

  @override
  Future<Either<Failure, List<User>>> call(Params params) async {
    return repository.getUsers(pages: params.pages, limit: params.limit);
  }
}

class Params {
  final int pages;
  final int limit;

  const Params({required this.pages, this.limit = Pagination.limit});
}
