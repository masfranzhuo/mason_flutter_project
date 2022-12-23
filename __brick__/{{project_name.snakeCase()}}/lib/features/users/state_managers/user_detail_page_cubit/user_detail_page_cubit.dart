import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/core/base/exception/exception.dart';
import 'package:flutter_project/features/users/models/user.dart';
import 'package:flutter_project/features/users/usecases/get_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'user_detail_page_cubit.freezed.dart';

@singleton
class UserDetailPageCubit extends Cubit<UserDetailPageState> {
  final GetUser _getUser;

  UserDetailPageCubit({
    required GetUser getUser,
  })  : _getUser = getUser,
        super(Initial());

  Future<void> getUser({required String id}) async {
    emit(Loading());
    final result = await _getUser(id);

    result.fold(
      (e) => emit(Error(e: e)),
      (user) => emit(Loaded(user: user)),
    );
  }
}

@freezed
class UserDetailPageState with _$UserDetailPageState {
  factory UserDetailPageState.initial() = Initial;
  factory UserDetailPageState.loading() = Loading;
  factory UserDetailPageState.error({required AppException e}) = Error;
  factory UserDetailPageState.loaded({required User user}) = Loaded;
}
