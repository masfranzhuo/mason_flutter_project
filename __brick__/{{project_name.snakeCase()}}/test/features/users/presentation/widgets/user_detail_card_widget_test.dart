import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/core/extensions/date_time_extension.dart';
import 'package:flutter_project/features/users/presentation/widgets/user_detail_card_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../helpers/model_helpers.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
    initializeDateFormatting('en_US');
  });

  Future<void> setUpEnvironment(WidgetTester tester) async {
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
      await setUpEnvironment(tester);

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

  testWidgets(
    'should find Column widget, with its value contains user detail data',
    (WidgetTester tester) async {
      await setUpEnvironment(tester);

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
                .contains(': ${user.dateOfBirth!.toDate()}')),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is Column &&
            w.children[6] is Padding &&
            (w.children[6] as Padding).child is Text &&
            ((w.children[6] as Padding).child as Text)
                .data!
                .contains(': ${user.registerDate!.toDate()}')),
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
