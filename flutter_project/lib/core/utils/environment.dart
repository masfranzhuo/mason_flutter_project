import 'package:flutter_project/core/config/base_config.dart';

class Environment {
  static const String development = 'DEVELOPMENT';
  static const String staging = 'STAGING';
  static const String production = 'PRODUCTION';

  late BaseConfig config;

  initConfig(String environment) async {
    if (environment == Environment.production) {
      config = ProductionConfig();
    } else if (environment == Environment.staging) {
      config = StagingConfig();
    } else {
      config = DevelopmentConfig();
    }
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  factory Environment() {
    return _singleton;
  }
}
