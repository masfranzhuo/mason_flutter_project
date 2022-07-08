import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/services/translator.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/widgets/user_detail_card_widget.dart';
import 'package:{{project_name.snakeCase()}}/src/state_managers/user_detail_page_cubit/user_detail_page_cubit.dart';
import 'package:get_it/get_it.dart';

class UserDetailPage extends StatelessWidget {
  final String id;

  const UserDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<UserDetailPageCubit>()..getUser(id: id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(GetIt.I<TranslatorService>().translate(
            context,
            'label.pages.userDetail.title',
          )),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => _builder(
            context,
            constraints,
          ),
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, BoxConstraints constraints) {
    return BlocConsumer<UserDetailPageCubit, UserDetailPageState>(
      listener: (context, state) {
        if (state.failure != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.failure!.message),
            ));
        }
      },
      builder: (context, state) {
        return state.isLoading || state.failure != null
            ? const Center(child: CircularProgressIndicator())
            : UserDetailCardWidget(user: state.user!);
      },
    );
  }
}
