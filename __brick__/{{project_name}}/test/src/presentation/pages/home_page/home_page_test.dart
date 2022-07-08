// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/core/config/base_config.dart';
import 'package:{{project_name.snakeCase()}}/core/services/translator.dart';
import 'package:{{project_name.snakeCase()}}/src/presentation/pages/home_page/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../mock_helpers.dart';

void main() {
  late MockBaseConfig mockBaseConfig;
  late MockTranslatorService mockTranslatorService;

  setUp(() {
    mockBaseConfig = MockBaseConfig();
    mockTranslatorService = MockTranslatorService();

    GetIt.I.registerLazySingleton<BaseConfig>(
      () => mockBaseConfig,
    );
    GetIt.I.registerLazySingleton<TranslatorService>(
      () => mockTranslatorService,
    );
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
