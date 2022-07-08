import 'package:injectable/injectable.dart';

abstract class BaseConfig {
  String get appName;
  String get envFileName;
  bool get showDebugInfo;
}

@Injectable(as: BaseConfig, env: [Environment.dev])
class DevConfig implements BaseConfig {
  @override
  String get appName => 'Flutter Demo Dev';

  @override
  String get envFileName => '.env_dev';

  @override
  bool get showDebugInfo => true;
}

@Injectable(as: BaseConfig, env: [Environment.prod])
class ProdConfig implements BaseConfig {
  @override
  String get appName => 'Flutter Demo Prod';

  @override
  String get envFileName => '.env';

  @override
  bool get showDebugInfo => false;
}
