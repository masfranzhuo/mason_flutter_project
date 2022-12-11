import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:{{project_name.snakeCase()}}/features/users/models/user.dart';
import 'package:{{project_name.snakeCase()}}/features/users/usecases/get_users.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'users_page_cubit.freezed.dart';

@singleton
class UsersPageCubit extends Cubit<UsersPageState> {
  final GetUsers _getUsers;

  UsersPageCubit({
    required GetUsers getUsers,
  })  : _getUsers = getUsers,
        super(Initial());

  Future<void> getUsers({bool isReload = false}) async {
    emit(Loading(
      page: isReload ? 0 : state.page,
      users: isReload ? [] : state.users,
    ));

    final params = GetUsersParams(page: state.page);
    final result = await _getUsers(params);

    result.fold(
      (e) => emit(Error(
        e: e,
        page: state.page,
        users: state.users,
      )),
      (users) => emit(Loaded(
        page: state.page + 1,
        users: [...state.users, ...users],
      )),
    );
  }
}

@freezed
class UsersPageState with _$UsersPageState {
  factory UsersPageState.initial({
    @Default([]) List<User> users,
    @Default(0) int page,
  }) = Initial;
  factory UsersPageState.loading({
    @Default([]) List<User> users,
    @Default(0) int page,
  }) = Loading;
  factory UsersPageState.error({
    @Default([]) List<User> users,
    @Default(0) int page,
    required AppException e,
  }) = Error;
  factory UsersPageState.loaded({
    @Default([]) List<User> users,
    @Default(0) int page,
  }) = Loaded;
}
