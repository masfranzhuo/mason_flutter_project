import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/src/use_cases/get_users.dart';
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

  void getUsers({bool isReload = false}) async {
    emit(Loading(
      page: isReload ? 0 : state.page,
      users: isReload ? [] : state.users,
    ));

    final result = await _getUsers(page: state.page);

    result.fold(
      (failure) => emit(Error(failure: failure, users: state.users)),
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
    required Failure failure,
  }) = Error;
  factory UsersPageState.loaded({
    @Default([]) List<User> users,
    @Default(0) int page,
  }) = Loaded;
}
