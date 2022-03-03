import 'base_config.dart';
import 'dart:io' show Platform;
import 'package:chat/constants/constants.dart';
import 'default_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProdConfig with DefaultConfig implements BaseConfig {
  @override
  String get apiHost => PROD_API_HOST;
  @override
  String get imDomain => PROD_IM_DOMAIN;
  @override
  String get clientId {
    var clientId = PROD_ANDROID_CLIENT_ID;
    if (Platform.isIOS) {
      clientId = PROD_IOS_CLIENT_ID;
    }
    if (clientId == "") {
      throw Exception("client id is not set");
    }
    return clientId;
  }

  @override
  String get clientSecret {
    if (Platform.isIOS) {
      return dotenv.get(PROD_IOS_CLIENT_SECRET_KEY);
    } else {
      return dotenv.get(PROD_ANDROID_CLIENT_SECRET_KEY);
    }
  }
}
