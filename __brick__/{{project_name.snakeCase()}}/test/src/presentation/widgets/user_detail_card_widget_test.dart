import 'dart:io';

import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/core/services/translator.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/widgets/user_detail_card_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../mock_helpers.dart';
import '../../entities/entity_helpers.dart';

void main() {
  late MockTranslatorService mockTranslatorService;

  setUpAll(() {
    HttpOverrides.global = null;
    initializeDateFormatting('en_US');
  });

  setUp(() {
    mockTranslatorService = MockTranslatorService();

    GetIt.I.registerLazySingleton<TranslatorService>(
      () => mockTranslatorService,
    );
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  Future<void> _setUpEnvironment(WidgetTester tester) async {
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, widget) => MaterialApp(
        home: UserDetailCardWidget(user: user),
      ),
    ));
  }

  testWidgets(
    'should find Card widget Column widget wrapped by Center, which contains 8 children',
    (WidgetTester tester) async {
      await _setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate((w) =>
            w is Card &&
            w.child is Center &&
            (w.child as Center).child is Column &&
            ((w.child as Center).child as Column).children.length == 8),
        findsOneWidget,
      );
    },
  );

  testWidgets('should translate these keys', (tester) async {
    await _setUpEnvironment(tester);

    String translate = 'model.user';
    verify(() => mockTranslatorService.translate(any(), '$translate.title'));
    verify(() => mockTranslatorService.translate(any(), '$translate.name'));
    verify(() => mockTranslatorService.translate(any(), '$translate.email'));
    verify(() => mockTranslatorService.translate(any(), '$translate.gender'));
    verify(
        () => mockTranslatorService.translate(any(), '$translate.dateOfBirth'));
    verify(() => mockTranslatorService.translate(any(), '$translate.joinFrom'));
    verify(() => mockTranslatorService.translate(any(), '$translate.address'));
  });

  testWidgets(
    'should find Column widget, with its value contains user detail data',
    (WidgetTester tester) async {
      await _setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate((w) =>
            w is Column &&
            w.children.first is Padding &&
            (w.children.first as Padding).child is ClipOval &&
            ((w.children.first as Padding).child as ClipOval).child is Image &&
            (((w.children.first as Padding).child as ClipOval).child as Image)
                .image is NetworkImage &&
            ((((w.children.first as Padding).child as ClipOval).child as Image)
                        .image as NetworkImage)
                    .url ==
                user.picture),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is Column &&
            w.children[1] is Padding &&
            (w.children[1] as Padding).child is Text &&
            ((w.children[1] as Padding).child as Text)
                .data!
                .contains(': ${user.title}')),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is Column &&
            w.children[2] is Padding &&
            (w.children[2] as Padding).child is Text &&
            ((w.children[2] as Padding).child as Text)
                .data!
                .contains(': ${user.firstName} ${user.lastName}')),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is Column &&
            w.children[3] is Padding &&
            (w.children[3] as Padding).child is Text &&
            ((w.children[3] as Padding).child as Text)
                .data!
                .contains(': ${user.email}')),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is Column &&
            w.children[4] is Padding &&
            (w.children[4] as Padding).child is Text &&
            ((w.children[4] as Padding).child as Text)
                .data!
                .contains(': ${user.gender}')),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is Column &&
            w.children[5] is Padding &&
            (w.children[5] as Padding).child is Text &&
            ((w.children[5] as Padding).child as Text)
                .data!
                .contains(': ${DateConfig.dateFormat(user.dateOfBirth!)}')),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is Column &&
            w.children[6] is Padding &&
            (w.children[6] as Padding).child is Text &&
            ((w.children[6] as Padding).child as Text)
                .data!
                .contains(': ${DateConfig.dateFormat(user.registerDate!)}')),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is Column &&
            w.children[7] is Padding &&
            (w.children[7] as Padding).child is Text &&
            ((w.children[7] as Padding).child as Text).data!.contains(
                ': ${user.location?.country}, ${user.location?.state}, ${user.location?.city}, ${user.location?.street}')),
        findsOneWidget,
      );
    },
  );
}
