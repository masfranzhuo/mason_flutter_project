import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/src/data_sources/user_data_source.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:injectable/injectable.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers({
    required int pages,
    int limit = Pagination.limit,
  });
  Future<Either<Failure, User>> getUser({required String id});
}

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<User>>> getUsers({
    required int pages,
    int limit = Pagination.limit,
  }) async {
    try {
      final result = await dataSource.getUsers(pages: pages, limit: limit);

      return Right(result);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUser({required String id}) async {
    try {
      final result = await dataSource.getUser(id: id);

      return Right(result);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
