import 'package:logger/logger.dart';

class Log {
  static late final Logger _instance;
  factory Log() {
    return _singleton;
  }

  Log._internal();

  static final Log _singleton = Log._internal();
  initLog(String env) {
    if (env == 'dev' || env == 'local' || env == 'test') {
      Logger.level = Level.debug;
    } else {
      Logger.level = Level.warning;

      // Logger.level = Level.warning;
    }
    _instance = Logger();
  }

  static var info = _instance.i;

  static var debug = _instance.d;
  static var verbose = _instance.v;

  static var warn = _instance.w;

  static var error = _instance.e;
}
