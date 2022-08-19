import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/core/services/translator.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/pages/user_detail_page/user_detail_page.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/widgets/user_detail_card_widget.dart';
import 'package:{{project_name.snakeCase()}}/src/state_managers/user_detail_page_cubit/user_detail_page_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../entities/entity_helpers.dart';
import '../../mock_helpers.dart';

void main() {
  late MockTranslatorService mockTranslatorService;
  late MockUserDetailPageCubit mockUserDetailPageCubit;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockTranslatorService = MockTranslatorService();
    mockUserDetailPageCubit = MockUserDetailPageCubit();

    GetIt.I.registerLazySingleton<TranslatorService>(
      () => mockTranslatorService,
    );
    GetIt.I.registerLazySingleton<UserDetailPageCubit>(
      () => mockUserDetailPageCubit,
    );
  });

  tearDown(() async {
    mockUserDetailPageCubit.close();
    await GetIt.I.reset();
  });

  Future<void> _setUpEnvironment(WidgetTester tester) async {
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, widget) => MaterialApp(
        home: UserDetailPage(id: user.id),
      ),
    ));
  }

  testWidgets('should translate these keys', (tester) async {
    when(() => mockUserDetailPageCubit.state).thenReturn(Loaded(user: user));
    await _setUpEnvironment(tester);

    verify(() =>
        mockTranslatorService.translate(any(), 'label.pages.userDetail.title'));
  });

  testWidgets(
    'should find CircularProgressIndicator widget, when state isLoading is true',
    (WidgetTester tester) async {
      when(() => mockUserDetailPageCubit.state).thenReturn(Loading());

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
    'should call getUser() and find UserDetailCardWidget widget, when user data is loaded',
    (WidgetTester tester) async {
      when(() => mockUserDetailPageCubit.state).thenReturn(Loaded(user: user));

      await _setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate((w) => w is UserDetailCardWidget),
        findsOneWidget,
      );

      verify(() => mockUserDetailPageCubit.getUser(id: user.id)).called(1);
    },
  );

  testWidgets(
    'should find "any message" text, when return failure',
    (WidgetTester tester) async {
      when(() => mockUserDetailPageCubit.state).thenReturn(Loaded(user: user));
      whenListen(
        mockUserDetailPageCubit,
        Stream.fromIterable([
          Error(failure: const UnexpectedFailure(message: 'any message')),
        ]),
      );

      await _setUpEnvironment(tester);
      await tester.pump();

      expect(find.text('any message'), findsOneWidget);
    },
  );
}
