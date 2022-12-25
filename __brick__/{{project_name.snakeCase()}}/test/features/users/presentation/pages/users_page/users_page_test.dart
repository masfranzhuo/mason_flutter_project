import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/features/users/presentation/pages/users_page/users_page.dart';
import 'package:{{project_name.snakeCase()}}/features/users/presentation/widgets/user_card_widget.dart';
import 'package:{{project_name.snakeCase()}}/features/users/state_managers/users_page_cubit/users_page_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/model_helpers.dart';
import '../../../../../helpers/mock_helpers.dart';

void main() {
  late MockUsersPageCubit mockUsersPageCubit;
  late MockGoRouter mockGoRouter;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockUsersPageCubit = MockUsersPageCubit();
    mockGoRouter = MockGoRouter();

    GetIt.I.registerLazySingleton<UsersPageCubit>(
      () => mockUsersPageCubit,
    );
  });

  tearDown(() async {
    mockUsersPageCubit.close();
    await GetIt.I.reset();
  });

  Future<void> setUpEnvironment(WidgetTester tester) async {
    when(() => mockUsersPageCubit.getUsers(isReload: any(named: 'isReload')))
        .thenAnswer((_) async => Unit);
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, widget) => MaterialApp(
        home: MockGoRouterProvider(
          goRouter: mockGoRouter,
          child: const UsersPage(),
        ),
      ),
    ));
  }

  testWidgets(
    'should find CircularProgressIndicator widget, when state isLoading is true',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState.loading(),
      );

      await setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate(
          (w) => w is Center && w.child is CircularProgressIndicator,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should find UserCardWidget widget, when users data is loaded',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState.loaded(users: users),
      );

      await setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate(
          (w) => w is UserCardWidget && w.user == users[0],
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should call getUsers(), when scroll into the bottom of page',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState.loading(users: users),
      );
      whenListen(
        mockUsersPageCubit,
        Stream.fromIterable([
          UsersPageState.loaded(users: [...users, ...users]),
        ]),
      );

      await setUpEnvironment(tester);

      // https://www.anycodings.com/1questions/1483720/flutter-how-to-test-the-scroll
      final listView = tester.widget<ListView>(find.byType(ListView));
      final ctrl = listView.controller;
      ctrl?.jumpTo(ctrl.offset + 300);
      await tester.pump();

      verify(() => mockUsersPageCubit.getUsers()).called(2);
    },
  );

  testWidgets(
    'should find CircularProgressIndicator widget, when scroll into the bottom of page',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState.loaded(users: users),
      );
      whenListen(
        mockUsersPageCubit,
        Stream.fromIterable([
          UsersPageState.loading(users: users),
        ]),
      );

      await setUpEnvironment(tester);

      // https://www.anycodings.com/1questions/1483720/flutter-how-to-test-the-scroll
      final listView = tester.widget<ListView>(find.byType(ListView));
      final ctrl = listView.controller;
      ctrl?.jumpTo(ctrl.offset + 300);
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Padding &&
              w.padding == const EdgeInsets.all(16) &&
              w.child is Center &&
              (w.child as Center).child is CircularProgressIndicator,
        ),
        findsOneWidget,
      );

      /// position of the scrollview
      ///
      // final gesture = await tester.startGesture(const Offset(0, 300));

      // /// how much to scroll by
      // ///
      // await gesture.moveBy(const Offset(0, -300));
      // await tester.pump();

      // await tester.dragUntilVisible(
      //   find.byWidgetPredicate(
      //     (w) => w is UserCardWidget && w.user == users.last,
      //   ),
      //   find.byKey(const Key('users-page-list-view')),
      //   const Offset(0, -300),
      // );
      // await tester.pump();

      verify(() => mockUsersPageCubit.getUsers()).called(1);
    },
  );

  testWidgets(
    'should call getUsers(isReload: true), when use refresh indicator',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState.loaded(users: users),
      );

      final SemanticsHandle handle = tester.ensureSemantics();
      await setUpEnvironment(tester);

      await tester.fling(
        find.byWidgetPredicate(
          (w) => w is UserCardWidget && w.user == users[0],
        ),
        const Offset(0, 300),
        1000,
      );
      await tester.pump();

      expect(
        tester.getSemantics(find.byType(RefreshProgressIndicator)),
        matchesSemantics(label: 'Refresh'),
      );

      /// finish the scroll animation
      ///
      await tester.pump(const Duration(seconds: 1));

      /// finish the indicator settle animation
      ///
      await tester.pump(const Duration(seconds: 1));

      /// finish the indicator hide animation
      ///
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockUsersPageCubit.getUsers(isReload: true)).called(1);

      handle.dispose();
    },
  );

  testWidgets(
    'should verify navigate to UserDetailPage, when tap at IconButton',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState.loaded(users: users),
      );
      await setUpEnvironment(tester);

      final tapable = find.byKey(
        Key('user-card-widget-icon-button-key-${users[0].id}'),
      );
      await tester.tap(tapable);
      await tester.pumpAndSettle();

      verify(() => mockGoRouter.go('/user-detail/${users[0].id}')).called(1);
    },
  );
}
