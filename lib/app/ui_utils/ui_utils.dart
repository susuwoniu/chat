import 'package:chat/app/providers/auth_provider.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:chat/errors/errors.dart';
import 'package:chat/utils/log.dart';
import 'package:chat/app/routes/app_pages.dart';

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
  static reportError(e) {
    Log.error(e);
    // TODO
  }

  static showError(e) async {
    // log
    Log.error(e);
    if (e is ServiceException) {
      // 如果是登录错误的话，跳转到登陆页
      if (e.code == 'unauthorized_error' || e.status == 401) {
        // get current route
        final currentRoute = Get.currentRoute;
        Log.debug("currentRoute: $currentRoute");
        AuthProvider.to.setNextPage(currentRoute);
        Get.offNamed(Routes.LOGIN);
        return;
      }
      return snackbar(
        e.title,
        e.detail,
      );
    } else {
      return snackbar(
        "",
        e.toString(),
      );
    }
  }

  static snackbar(String title, String message,
      {SnackPosition snackPosition = SnackPosition.BOTTOM}) async {
    return Get.snackbar(title, message,
        snackPosition: snackPosition,
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
