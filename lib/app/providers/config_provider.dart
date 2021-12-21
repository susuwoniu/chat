import 'package:flutter/material.dart';
import 'package:chat/constants/constants.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'kv_provider.dart';
import 'package:chat/utils/log.dart';

class ConfigProvider extends GetxService {
  static ConfigProvider get to => Get.find();

  bool isFirstOpen = false;
  PackageInfo? _platform;
  String get version => _platform?.version ?? '-';
  bool get isRelease => bool.fromEnvironment("dart.vm.product");
  Locale locale = Locale('en', 'US');
  List<Locale> languages = [
    Locale('en', 'US'),
    Locale('zh', 'CN'),
  ];
  final nightMode = false.obs;
  // 跳过看过的帖子
  final skipViewedPost = true.obs;
  @override
  void onInit() {
    isFirstOpen = KVProvider.to.getBool(STORAGE_DEVICE_FIRST_OPEN_KEY);
    Log.debug("isFirstOpen: $isFirstOpen");
    nightMode.value = KVProvider.to.getBool(NIGHT_MODE_KEY);
    skipViewedPost.value =
        KVProvider.to.getBool(SKIP_VIEWED_POST_KEY, defaultValue: true);

    super.onInit();
  }

  toggleNightMode(bool value) {
    nightMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);

    KVProvider.to.setBool(NIGHT_MODE_KEY, nightMode.value);
  }

  toggleSkipViewedPost() {
    skipViewedPost.value = !skipViewedPost.value;

    KVProvider.to.setBool(SKIP_VIEWED_POST_KEY, skipViewedPost.value);
  }

  Future<void> getPlatform() async {
    _platform = await PackageInfo.fromPlatform();
  }

  // 标记用户已打开APP
  Future<void> saveAlreadyOpen() {
    return KVProvider.to.setBool(STORAGE_DEVICE_FIRST_OPEN_KEY, false);
  }

  void onInitLocale() {
    var langCode = KVProvider.to.getString(STORAGE_LANGUAGE_CODE);
    if (langCode == null) return;
    var index = languages.indexWhere((element) {
      return element.languageCode == langCode;
    });
    if (index < 0) return;
    locale = languages[index];
  }

  void onLocaleUpdate(Locale value) {
    locale = value;
    Get.updateLocale(value);
    KVProvider.to.setString(STORAGE_LANGUAGE_CODE, value.languageCode);
  }
}
