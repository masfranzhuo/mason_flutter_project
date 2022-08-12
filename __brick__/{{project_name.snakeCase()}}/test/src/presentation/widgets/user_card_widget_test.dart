import 'dart:io';

import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/widgets/user_card_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock_helpers.dart';
import '../../entities/entity_helpers.dart';

/// TODO: image network error test
///
void main() {
  late MockOnTap mockOnTap;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockOnTap = MockOnTap();
  });

  Future<void> _setUpEnvironment(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: UserCardWidget(
        user: user,
        onTap: (context) => mockOnTap(context),
      ),
    ));
  }

  testWidgets(
    'should find Card widget ListTile widget',
    (WidgetTester tester) async {
      await _setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate((w) => w is Card && w.child is ListTile),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should find ListTile widget, with its value contains user detail data',
    (WidgetTester tester) async {
      await _setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate((w) =>
            w is ListTile &&
            w.leading is ClipOval &&
            (w.leading as ClipOval).child is Image &&
            ((w.leading as ClipOval).child as Image).image is NetworkImage &&
            (((w.leading as ClipOval).child as Image).image as NetworkImage)
                    .url ==
                user.picture),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is ListTile &&
            w.title is Text &&
            (w.title as Text).data == user.firstName),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is ListTile &&
            w.subtitle is Text &&
            (w.subtitle as Text).data == user.lastName),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should find IconButton with Icon = Icons.navigate_next and call onTap when pressed',
    (WidgetTester tester) async {
      await _setUpEnvironment(tester);

      expect(
        find.byWidgetPredicate((w) =>
            w is ListTile &&
            w.trailing is IconButton &&
            (w.trailing as IconButton).icon is Icon &&
            ((w.trailing as IconButton).icon as Icon).icon ==
                Icons.navigate_next),
        findsOneWidget,
      );

      final button = find.byType(IconButton);
      await tester.tap(button);

      verify(() => mockOnTap(any())).called(1);
    },
  );
}
