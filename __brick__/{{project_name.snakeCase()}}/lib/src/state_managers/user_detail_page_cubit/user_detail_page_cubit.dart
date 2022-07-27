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
        super(UserDetailPageState());

  void getUser({required String id}) async {
    emit(UserDetailPageState().copyWith(isLoading: true));

    final result = await _getUser(id);

    result.fold(
      (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
      (user) => emit(state.copyWith(isLoading: false, user: user)),
    );
  }
}

@freezed
class UserDetailPageState with _$UserDetailPageState {
  const UserDetailPageState._();
  factory UserDetailPageState({
    Failure? failure,
    @Default(false) bool isLoading,
    User? user,
  }) = _UserDetailPageState;
}
