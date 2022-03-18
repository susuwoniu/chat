import 'package:chat/app/providers/push_provider.dart';
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
import 'dart:async';

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
    final String env = dotenv.env['ENV'] ?? AppConfig.PROD;

    AppConfig().initConfig(env);
    Log().initLog(env);
    await GetStorage.init();
    await CacheProvider.to.initial();
    await SimpleAccountMapCacheProvider.to.initial();
    await AccountStoreProvider.to.initial();
    await KVProvider.to.init();
    await Global.initGetx();

    Timeline.finishSync();
    print('global init finish');
  }

  static Future<void> initGetx() async {
    await Get.put<RouterProvider>(RouterProvider());
    await Get.put<PushProvider>(PushProvider());
    await Get.put<AccountProvider>(AccountProvider());
    await Get.put<ConfigProvider>(ConfigProvider());
    await Get.put<AuthProvider>(AuthProvider());
    await Get.put<ChatProvider>(ChatProvider());
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

  runOnetimeTask() async {
    print("run onetime task ...");

    // update me
    if (AuthProvider.to.isLogin) {
      try {
        await AccountProvider.to.getMe();
      } catch (e) {
        Log.error("Can not get me at global run one time task $e");
      }
    }
  }

  Timer? _globalTaskTimer;
  runGlobalTask() async {
    // check refresh token
    // refresh token
    print("run runGlobalTask...");
    if (AuthProvider.to.isNeedRenewToken() &&
        AuthProvider.to.refreshToken != null) {
      try {
        await APIProvider.to.renewToken();
      } catch (e) {
        // ignore
        print("renew token failed, $e");
      }
    }
    _globalTaskTimer = Timer(const Duration(minutes: 1), () async {
      runGlobalTask();
    });
  }

  dispose() {
    _globalTaskTimer?.cancel();
  }
}
