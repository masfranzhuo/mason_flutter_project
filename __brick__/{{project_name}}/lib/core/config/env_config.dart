import 'package:{{project_name}}.snakeCase()}}/core/utils/environment.dart';

class EnvConfig {
  static const appName = String.fromEnvironment('DEFINE_APP_NAME');
  static const appSuffix = String.fromEnvironment('DEFINE_APP_SUFFIX');
  static const environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.development,
  );
}
