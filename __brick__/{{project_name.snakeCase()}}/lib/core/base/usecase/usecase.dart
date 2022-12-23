import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/base/exception/exception.dart';

abstract class AppUsecase<T, Params> {
  Future<Either<AppException, T>> call(Params params);
}

class NoParams {}
