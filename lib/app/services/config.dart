import 'package:flutter/material.dart';
import 'package:chat/constants/constants.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import './kv.dart';

class ConfigService extends GetxService {
  static ConfigService get to => Get.find();

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

  @override
  void onInit() {
    super.onInit();
    isFirstOpen = KVService.to.getBool(STORAGE_DEVICE_FIRST_OPEN_KEY);
    nightMode.value = KVService.to.getBool(NIGHT_MODE_KEY);
  }

  toggleNightMode(bool value) {
    nightMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);

    KVService.to.setBool(NIGHT_MODE_KEY, nightMode.value);
  }

  Future<void> getPlatform() async {
    _platform = await PackageInfo.fromPlatform();
  }

  // 标记用户已打开APP
  Future<bool> saveAlreadyOpen() {
    return KVService.to.setBool(STORAGE_DEVICE_FIRST_OPEN_KEY, false);
  }

  void onInitLocale() {
    var langCode = KVService.to.getString(STORAGE_LANGUAGE_CODE);
    if (langCode.isEmpty) return;
    var index = languages.indexWhere((element) {
      return element.languageCode == langCode;
    });
    if (index < 0) return;
    locale = languages[index];
  }

  void onLocaleUpdate(Locale value) {
    locale = value;
    Get.updateLocale(value);
    KVService.to.setString(STORAGE_LANGUAGE_CODE, value.languageCode);
  }
}
