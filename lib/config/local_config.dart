import 'base_config.dart';
import 'dart:io' show Platform;
import 'package:chat/constants/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'default_config.dart';

class LocalConfig with DefaultConfig implements BaseConfig {
  @override
  String get apiHost {
    return dotenv.get(LOCAL_API_HOST_KEY);
  }

  @override
  String get imDomain => DEV_IM_DOMAIN;
  @override
  String get clientId {
    if (Platform.isIOS) {
      return DEV_IOS_CLIENT_ID;
    } else {
      return DEV_ANDROID_CLIENT_ID;
    }
  }

  @override
  String get clientSecret {
    if (Platform.isIOS) {
      return dotenv.get(DEV_IOS_CLIENT_SECRET_KEY);
    } else {
      return dotenv.get(DEV_ANDROID_CLIENT_SECRET_KEY);
    }
  }
}
