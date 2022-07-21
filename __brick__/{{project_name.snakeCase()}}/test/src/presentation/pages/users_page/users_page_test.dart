import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/core/services/translator.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/pages/user_detail_page/user_detail_page.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/pages/users_page/users_page.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/widgets/user_card_widget.dart';
import 'package:{{project_name.snakeCase()}}/src/state_managers/user_detail_page_cubit/user_detail_page_cubit.dart';
import 'package:{{project_name.snakeCase()}}/src/state_managers/users_page_cubit/users_page_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../entities/entity_helpers.dart';
import '../../mock_helpers.dart';

void main() {
  late MockTranslatorService mockTranslatorService;
  late MockUsersPageCubit mockUsersPageCubit;
  late MockNavigatorObserver mockObserver;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockTranslatorService = MockTranslatorService();
    mockUsersPageCubit = MockUsersPageCubit();
    mockObserver = MockNavigatorObserver();

    GetIt.I.registerLazySingleton<TranslatorService>(
      () => mockTranslatorService,
    );
    GetIt.I.registerLazySingleton<UsersPageCubit>(
      () => mockUsersPageCubit,
    );
  });

  tearDown(() async {
    mockUsersPageCubit.close();
    await GetIt.I.reset();
  });

  Future<void> _setUpEnvironment(WidgetTester tester) async {
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, widget) => MaterialApp(
        navigatorObservers: [mockObserver],
        home: const UsersPage(),
      ),
    ));
  }

  testWidgets('should translate these keys', (tester) async {
    when(() => mockUsersPageCubit.state).thenReturn(UsersPageState());
    await _setUpEnvironment(tester);

    String translate = 'label';
    verify(() =>
        mockTranslatorService.translate(any(), '$translate.pages.users.title'));
    verify(() =>
        mockTranslatorService.translate(any(), '$translate.button.loadMore'));
  });

  testWidgets(
    'should find CircularProgressIndicator widget, when state isLoading is true',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState(isLoading: true),
      );

      await _setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate(
          (w) => w is Center && w.child is CircularProgressIndicator,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should find UserCardWidget widget, when users data is loaded with load more ElevatedButton',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState(users: users),
      );

      await _setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate(
          (w) => w is UserCardWidget && w.user == users[0],
        ),
        findsOneWidget,
      );
      expect(find.byType(ElevatedButton), findsOneWidget);
    },
  );

  testWidgets(
    'should call getUsers(), when tap at load more ElevatedButton',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState(),
      );
      whenListen(
        mockUsersPageCubit,
        Stream.fromIterable([
          UsersPageState(users: users),
        ]),
      );

      await _setUpEnvironment(tester);

      final button = find.byType(ElevatedButton);
      await tester.tap(button);

      verify(() => mockUsersPageCubit.getUsers()).called(2);
    },
  );

  testWidgets(
    'should call translate error code, when return NO_DATA_FAILURE failure code',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState(),
      );
      whenListen(
        mockUsersPageCubit,
        Stream.fromIterable([
          UsersPageState(
            failure: const UnexpectedFailure(
              code: 'NO_DATA_FAILURE',
              message: 'No more data available',
            ),
          ),
        ]),
      );

      await _setUpEnvironment(tester);

      verify(() =>
              mockTranslatorService.translate(any(), 'error.NO_DATA_FAILURE'))
          .called(1);
    },
  );

  testWidgets(
    'should call getUsers(isReload: true), when refresh indicator',
    (WidgetTester tester) async {
      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState(users: users),
      );

      final SemanticsHandle handle = tester.ensureSemantics();
      await _setUpEnvironment(tester);

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

      // finish the scroll animation
      await tester.pump(const Duration(seconds: 1));
      // finish the indicator settle animation
      await tester.pump(const Duration(seconds: 1));
      // finish the indicator hide animation
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockUsersPageCubit.getUsers(isReload: true)).called(1);

      handle.dispose();
    },
  );

  testWidgets(
    'should verify navigate to UserDetailPage, when tap at IconButton',
    (WidgetTester tester) async {
      final MockUserDetailPageCubit mockUserDetailPageCubit =
          MockUserDetailPageCubit();
      GetIt.I.registerLazySingleton<UserDetailPageCubit>(
        () => mockUserDetailPageCubit,
      );
      when(() => mockUserDetailPageCubit.state).thenReturn(
        UserDetailPageState(user: user),
      );

      when(() => mockUsersPageCubit.state).thenReturn(
        UsersPageState(users: users),
      );
      await _setUpEnvironment(tester);

      final tapable = find.byKey(
        Key('user-card-widget-icon-button-key-${users[0].id}'),
      );
      await tester.tap(tapable);
      await tester.pumpAndSettle();

      expect(find.byType(UsersPage), findsNothing);
      expect(find.byType(UserDetailPage), findsOneWidget);
      verify(() => mockObserver.didPush(any(), any()));
    },
  );
}
