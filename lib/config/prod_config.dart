import 'base_config.dart';
import 'dart:io' show Platform;
import 'package:chat/constants/constants.dart';
import 'default_config.dart';

class ProdConfig with DefaultConfig implements BaseConfig {
  @override
  String get apiHost => PROD_API_HOST;
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
    var clientSecret = PROD_ANDROID_CLIENT_SECRET_KEY;
    if (Platform.isIOS) {
      clientSecret = PROD_IOS_CLIENT_SECRET_KEY;
    }
    if (clientSecret == "") {
      throw Exception("client secret is not set");
    }
    return clientSecret;
  }
}
