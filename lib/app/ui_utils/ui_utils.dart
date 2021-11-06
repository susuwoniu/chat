import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';

class UIUtils {
  UIUtils() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 35.0
      ..lineWidth = 2
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.black.withOpacity(0.7)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.6)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  static snackbar(String title, String message) async {
    return Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        backgroundColor: Get.context?.theme.secondaryHeaderColor);
  }

  static void showLoading([String? text]) {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(status: text ?? 'Loading...');
  }

  static void toast(String text) {
    EasyLoading.showToast(text);
  }

  static void hideLoading() {
    EasyLoading.instance.userInteractions = true;
    EasyLoading.dismiss();
  }
}
