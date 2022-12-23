import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/features/users/presentation/widgets/user_card_widget.dart';
import 'package:flutter_project/features/users/state_managers/users_page_cubit/users_page_cubit.dart';
import 'package:flutter_project/generated/locale_keys.g.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll <= currentScroll) {
        GetIt.I<UsersPageCubit>().state.mapOrNull(loaded: (_) async {
          await GetIt.I<UsersPageCubit>().getUsers();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<UsersPageCubit>()..getUsers(),
      child: RefreshIndicator(
        onRefresh: () async {
          await GetIt.I<UsersPageCubit>().getUsers(isReload: true);
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(LocaleKeys.label_pages_users_title.tr()),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) => _builder(
                context,
                constraints,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, BoxConstraints constraints) {
    return BlocConsumer<UsersPageCubit, UsersPageState>(
      listener: (context, state) {
        state.whenOrNull(error: (_, __, e) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(tr('error.${e.code}'))));
        });
      },
      builder: (context, state) {
        if (state is Loading && state.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          key: const Key('users-page-list-view'),
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: state.users.length,
          itemBuilder: (context, index) {
            final user = state.users[index];
            final List<Widget> widgets = [
              UserCardWidget(
                user: user,
                onTap: (context) {
                  GoRouter.of(context).go('/user-detail/${user.id}');
                },
              ),
            ];

            if (index == state.users.length - 1) {
              state.mapOrNull(loading: (_) {
                widgets.add(const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ));
              });
            }

            return Column(children: widgets);
          },
        );
      },
    );
  }
}
