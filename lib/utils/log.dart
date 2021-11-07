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
    }
    _instance = Logger();
  }

  static void info(msg) {
    _instance.i(msg);
  }

  static void debug(msg) {
    _instance.d(msg);
  }

  static void warn(msg) {
    _instance.w(msg);
  }

  static void error(e) {
    // TODO report error
    _instance.e(e);
  }
}
