import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:{{project_name.snakeCase()}}/features/users/presentation/pages/user_detail_page/user_detail_page.dart';
import 'package:{{project_name.snakeCase()}}/features/users/presentation/widgets/user_detail_card_widget.dart';
import 'package:{{project_name.snakeCase()}}/features/users/state_managers/user_detail_page_cubit/user_detail_page_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/model_helpers.dart';
import '../../../../../helpers/mock_helpers.dart';

void main() {
  late MockUserDetailPageCubit mockUserDetailPageCubit;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockUserDetailPageCubit = MockUserDetailPageCubit();

    GetIt.I.registerLazySingleton<UserDetailPageCubit>(
      () => mockUserDetailPageCubit,
    );
  });

  tearDown(() async {
    mockUserDetailPageCubit.close();
    await GetIt.I.reset();
  });

  Future<void> setUpEnvironment(WidgetTester tester) async {
    when(() => mockUserDetailPageCubit.getUser(id: any(named: 'id')))
        .thenAnswer((_) async => Unit);
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, widget) => MaterialApp(
        home: UserDetailPage(id: user.id),
      ),
    ));
  }

  testWidgets(
    'should find CircularProgressIndicator widget, when state is Initial',
    (WidgetTester tester) async {
      when(() => mockUserDetailPageCubit.state).thenReturn(Initial());

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
    'should find CircularProgressIndicator widget, when state is Loading',
    (WidgetTester tester) async {
      when(() => mockUserDetailPageCubit.state).thenReturn(Loading());

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
    'should call getUser() and find UserDetailCardWidget widget, when user data is loaded',
    (WidgetTester tester) async {
      when(() => mockUserDetailPageCubit.state).thenReturn(Loaded(user: user));

      await setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate((w) => w is UserDetailCardWidget),
        findsOneWidget,
      );

      verify(() => mockUserDetailPageCubit.getUser(id: user.id)).called(1);
    },
  );

  testWidgets(
    'should find "any message" text, when return exception',
    (WidgetTester tester) async {
      when(() => mockUserDetailPageCubit.state).thenReturn(Loaded(user: user));
      whenListen(
        mockUserDetailPageCubit,
        Stream.fromIterable([
          Error(e: const AppException(message: 'any message')),
        ]),
      );

      await setUpEnvironment(tester);
      await tester.pump();

      expect(find.text('any message'), findsOneWidget);
    },
  );
}
