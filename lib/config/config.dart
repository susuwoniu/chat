import 'base_config.dart';
import 'dev_config.dart';
import 'prod_config.dart';
import 'local_config.dart';

class AppConfig {
  factory AppConfig() {
    return _singleton;
  }
  static AppConfig get to => _singleton;

  AppConfig._internal();

  static final AppConfig _singleton = AppConfig._internal();

  static const String DEV = 'dev';
  static const String STAGING = 'staging';
  static const String LOCAL = 'local';
  static const String PROD = 'prod';

  late BaseConfig config;
  late String _env;
  String get env => _env;
  bool get isDev => _env == DEV || _env == LOCAL;
  initConfig(String env) {
    _env = env;
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
