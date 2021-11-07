import 'base_config.dart';
import 'dev_config.dart';
import 'prod_config.dart';
import 'local_config.dart';

class AppConfig {
  factory AppConfig() {
    return _singleton;
  }

  AppConfig._internal();

  static final AppConfig _singleton = AppConfig._internal();

  static const String DEV = 'dev';
  static const String STAGING = 'staging';
  static const String LOCAL = 'local';
  static const String PROD = 'prod';

  late BaseConfig config;

  initConfig(String env) {
    config = _getConfig(env);
  }

  BaseConfig _getConfig(String env) {
    switch (env) {
      case AppConfig.PROD:
        return ProdConfig();
      case AppConfig.LOCAL:
        return LocalConfig();
      default:
        return DevConfig();
    }
  }
}
