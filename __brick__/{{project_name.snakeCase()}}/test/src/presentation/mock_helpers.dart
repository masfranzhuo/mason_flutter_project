import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/core/config/base_config.dart';
import 'package:{{project_name.snakeCase()}}/core/services/translator.dart';
import 'package:{{project_name.snakeCase()}}/src/state_managers/user_detail_page_cubit/user_detail_page_cubit.dart';
import 'package:{{project_name.snakeCase()}}/src/state_managers/users_page_cubit/users_page_cubit.dart';
import 'package:mocktail/mocktail.dart';

class FakeBuildContext extends Fake implements BuildContext {}

/// function
///
abstract class OnTap {
  void call(BuildContext context);
}

class MockOnTap extends Mock implements OnTap {
  MockOnTap() {
    registerFallbackValue(FakeBuildContext());
  }
}

/// translator service
///
class MockTranslatorService extends Mock implements TranslatorServiceImpl {
  MockTranslatorService() {
    registerFallbackValue(FakeBuildContext());

    when(
      () => translate(
        any(),
        any(),
        translationParams: any(named: 'translationParams'),
        fallbackKey: any(named: 'fallbackKey'),
      ),
    ).thenReturn('anyString');
  }
}

/// navigation
///
class FakeRoute extends Fake implements Route<dynamic> {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {
  MockNavigatorObserver() {
    registerFallbackValue(FakeRoute());
  }
}

/// cubits
///
class MockUsersPageCubit extends MockCubit<UsersPageState>
    implements UsersPageCubit {}

class FakeUsersPageState extends Fake implements UsersPageState {}

class MockUserDetailPageCubit extends MockCubit<UserDetailPageState>
    implements UserDetailPageCubit {}

class FakeUserDetailPageState extends Fake implements UserDetailPageState {}

/// base config
///
class MockBaseConfig extends Mock implements BaseConfig {
  MockBaseConfig() {
    when(() => appName).thenReturn('any string');
  }
}
