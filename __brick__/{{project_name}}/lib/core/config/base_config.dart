abstract class BaseConfig {
  String get appName;
  String get baseUrl;
  String get envFileName;
  bool get showDebugInfo;
}

class DevelopmentConfig implements BaseConfig {
  @override
  String get appName => 'Flutter Demo Development';

  @override
  String get baseUrl => 'https://dummyapi.io/data/v1/';

  @override
  String get envFileName => '.env_dev';

  @override
  bool get showDebugInfo => true;
}

class StagingConfig implements BaseConfig {
  @override
  String get appName => 'Flutter Demo Staging';

  @override
  String get baseUrl => 'https://dummyapi.io/data/v1/';

  @override
  String get envFileName => '.env_staging';

  @override
  bool get showDebugInfo => true;
}

class ProductionConfig implements BaseConfig {
  @override
  String get appName => 'Flutter Demo Production';

  @override
  String get baseUrl => 'https://dummyapi.io/data/v1/';

  @override
  String get envFileName => '.env';

  @override
  bool get showDebugInfo => false;
}
