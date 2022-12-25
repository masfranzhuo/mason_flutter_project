import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';

abstract class BaseUsecase<T, Params> {
  Future<Either<AppException, T>> call(Params params);
}

class NoParams {}
