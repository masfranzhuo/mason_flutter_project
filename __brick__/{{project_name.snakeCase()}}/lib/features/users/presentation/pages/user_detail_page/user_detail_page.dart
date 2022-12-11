import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/users/presentation/widgets/user_detail_card_widget.dart';
import 'package:{{project_name.snakeCase()}}/features/users/state_managers/user_detail_page_cubit/user_detail_page_cubit.dart';
import 'package:{{project_name.snakeCase()}}/generated/locale_keys.g.dart';
import 'package:get_it/get_it.dart';

class UserDetailPage extends StatelessWidget {
  final String id;

  const UserDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<UserDetailPageCubit>()..getUser(id: id),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.label_pages_userDetail_title.tr()),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) => _builder(context, constraints),
          ),
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, BoxConstraints constraints) {
    return BlocBuilder<UserDetailPageCubit, UserDetailPageState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e) => Center(child: Text(e.message)),
          loaded: (user) => UserDetailCardWidget(user: user),
        );
      },
    );
  }
}
