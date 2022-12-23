import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/base/usecase/usecase.dart';
import 'package:flutter_project/core/config/general_config.dart';
import 'package:flutter_project/core/base/exception/exception.dart';
import 'package:flutter_project/features/users/models/user.dart';
import 'package:flutter_project/features/users/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUsers extends AppUsecase<List<User>, GetUsersParams> {
  final UserRepository repository;

  GetUsers({required this.repository});

  @override
  Future<Either<AppException, List<User>>> call(GetUsersParams params) async {
    final result = await repository.getUsers(
      page: params.page,
      limit: params.limit,
    );
    return result.fold(
      (e) => Left(e),
      (users) {
        if (users.isEmpty) {
          return const Left(AppException(
            code: 'NO_DATA_ERROR',
            message: 'No more data available',
          ));
        } else {
          return Right(users);
        }
      },
    );
  }
}

class GetUsersParams {
  final int page, limit;

  GetUsersParams({
    required this.page,
    this.limit = PaginationConfig.limit,
  });
}
