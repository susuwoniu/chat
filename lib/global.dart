import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chat/config/config.dart';
import 'package:chat/utils/log.dart';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';

/// 全局静态数据
class Global {
  /// 初始化
  static Future init() async {
    Timeline.startSync('global init function');

    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    setSystemUi();
    // 初始化全局ui工具
    UIUtils();
    // Create storage
    // final storage = new FlutterSecureStorage();
    // await storage.write(
    //     key: STORAGE_CLIENT_SECRET_KEY,
    //     value: value,
    //     iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
    //     aOptions: AndroidOptions(
    //       encryptedSharedPreferences: true,
    //     ));
    await dotenv.load(fileName: ".env");
    // check must env variables
    const String env = String.fromEnvironment(
      'env',
      defaultValue: AppConfig.DEV,
    );

    AppConfig().initConfig(env);
    Log().initLog(env);
    await GetStorage.init();
    await CacheProvider.to.init();
    await SimpleAccountMapCacheProvider.to.init();
    await AccountStoreProvider.to.init();
    await KVProvider.to.init();
    await Global.initGetx();
    Timeline.finishSync();
    print('global init finish');
  }

  static Future<void> initGetx() async {
    Get.put<RouterProvider>(RouterProvider());
    Get.put<AccountProvider>(AccountProvider());
    Get.put<ConfigProvider>(ConfigProvider());
    Get.put<AuthProvider>(AuthProvider());
    Get.put<ChatProvider>(ChatProvider());
  }

  static void setSystemUi() {
    if (GetPlatform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}
