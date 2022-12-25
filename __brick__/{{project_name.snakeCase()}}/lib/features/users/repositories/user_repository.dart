import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:{{project_name.snakeCase()}}/core/base/repository/repository.dart';
import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/features/users/data_sources/user_network_data_source.dart';
import 'package:{{project_name.snakeCase()}}/features/users/data_sources/user_local_data_source.dart';
import 'package:{{project_name.snakeCase()}}/features/users/models/user.dart';
import 'package:injectable/injectable.dart';

abstract class UserRepository extends BaseRepository {
  Future<Either<AppException, List<User>>> getUsers({
    required int page,
    int limit = PaginationConfig.limit,
  });
  Future<Either<AppException, User>> getUser({required String id});
}

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserNetworkDataSource networkDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.networkDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<AppException, List<User>>> getUsers({
    required int page,
    int limit = PaginationConfig.limit,
  }) async {
    try {
      final result = await networkDataSource.getUsers(page: page, limit: limit);
      await localDataSource.addUsers(users: result);

      return Right(result);
    } on InternetConnectionException catch (e) {
      /// pagination not working properly when get data from local data source,
      /// because the rest api pagination start from 0 not 1,
      /// this will not happen if the page start from the same number,
      /// so ignored it on this project, rather than over code
      ///
      final result = await localDataSource.getUsers(
        page: page + 1,
        limit: limit,
      );
      if (result.isNotEmpty) {
        return Right(result);
      }

      return Left(e);
    } on AppException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, User>> getUser({required String id}) async {
    try {
      final result = await networkDataSource.getUser(id: id);
      await localDataSource.addUser(user: result);

      return Right(result);
    } on InternetConnectionException catch (e) {
      return Left(e);
    } on AppException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }
}
