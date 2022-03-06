import 'package:chat/constants/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

mixin DefaultConfig {
  String get apiPathPrefix => API_PATH_PREFIX;
  String get version => "0.1.0";
  String get jiguangAppKey {
    return dotenv.get(JIGUANG_APP_KEY);
  }
}
