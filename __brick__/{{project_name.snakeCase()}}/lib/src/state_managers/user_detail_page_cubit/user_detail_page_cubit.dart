import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/src/use_cases/get_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'user_detail_page_cubit.freezed.dart';

@singleton
class UserDetailPageCubit extends Cubit<UserDetailPageState> {
  final GetUser _getUser;

  UserDetailPageCubit({
    required GetUser getUser,
  })  : _getUser = getUser,
        super(Loading());

  void getUser({required String id}) async {
    final result = await _getUser(id: id);

    result.fold(
      (failure) => emit(Error(failure: failure)),
      (user) => emit(Loaded(user: user)),
    );
  }
}

@freezed
class UserDetailPageState with _$UserDetailPageState {
  factory UserDetailPageState.loading() = Loading;
  factory UserDetailPageState.error({required Failure failure}) = Error;
  factory UserDetailPageState.loaded({required User user}) = Loaded;
}
