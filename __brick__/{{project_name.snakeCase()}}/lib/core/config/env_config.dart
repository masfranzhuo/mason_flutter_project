import 'package:injectable/injectable.dart';

class EnvConfig {
  static const appName = String.fromEnvironment('DEFINE_APP_NAME');
  static const appSuffix = String.fromEnvironment('DEFINE_APP_SUFFIX');
  static const environment = String.fromEnvironment(
    'ENV',
    defaultValue: Environment.dev,
  );
}
