import 'package:bloc/bloc.dart';
import 'package:{{project_name}}.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name}}.snakeCase()}}/src/entities/user.dart';
import 'package:{{project_name}}.snakeCase()}}/src/use_cases/get_users.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'users_page_cubit.freezed.dart';

@singleton
class UsersPageCubit extends Cubit<UsersPageState> {
  final GetUsers _getUsers;

  UsersPageCubit({
    required GetUsers getUsers,
  })  : _getUsers = getUsers,
        super(UsersPageState());

  void getUsers({bool isReload = false}) async {
    emit(state.copyWith(
      isLoading: true,
      failure: null,
      pages: isReload ? 0 : state.pages,
      users: isReload ? [] : state.users,
    ));

    final result = await _getUsers(Params(pages: state.pages));

    result.fold(
      (failure) => emit(state.copyWith(
        failure: failure,
        isLoading: false,
      )),
      (users) {
        if (users.isEmpty) {
          emit(state.copyWith(
            failure: const UnexpectedFailure(
              code: 'NO_DATA_FAILURE',
              message: 'No more data available',
            ),
            isLoading: false,
          ));
          return;
        }
        emit(state.copyWith(
          isLoading: false,
          pages: state.pages + 1,
          users: [...state.users, ...users],
        ));
      },
    );
  }
}

@freezed
class UsersPageState with _$UsersPageState {
  const UsersPageState._();
  factory UsersPageState({
    Failure? failure,
    @Default(false) bool isLoading,
    @Default([]) List<User> users,
    @Default(0) int pages,
  }) = _UsersPageState;
}
