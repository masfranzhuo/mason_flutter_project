import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/services/translator.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/pages/user_detail_page/user_detail_page.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/widgets/user_card_widget.dart';
import 'package:{{project_name.snakeCase()}}/src/state_managers/users_page_cubit/users_page_cubit.dart';
import 'package:get_it/get_it.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<UsersPageCubit>()..getUsers(),
      child: RefreshIndicator(
        onRefresh: () async {
          GetIt.I<UsersPageCubit>().getUsers(isReload: true);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(GetIt.I<TranslatorService>().translate(
              context,
              'label.pages.users.title',
            )),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) => _builder(
              context,
              constraints,
            ),
          ),
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, BoxConstraints constraints) {
    return BlocConsumer<UsersPageCubit, UsersPageState>(
      listener: (context, state) {
        if (state.failure != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(
                GetIt.I<TranslatorService>().translate(
                  context,
                  'error.${state.failure?.code}',
                ),
              ),
            ));
        }
      },
      builder: (context, state) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserCardWidget(
                  user: user,
                  onTap: (context) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserDetailPage(id: user.id),
                    ));
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => GetIt.I<UsersPageCubit>().getUsers(),
                      child: Text(
                        GetIt.I<TranslatorService>().translate(
                          context,
                          'label.button.loadMore',
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
