import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:chat/common.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';

class BottomNavigationBarController extends GetxController {
  static BottomNavigationBarController get to => Get.find(); // add this line
  final backgroundColor = RxString("");
  // 页控制器
  late final PageController pageController;
  StreamSubscription? uriSub;

  /// scheme 内部打开
  bool isInitialUriIsHandled = false;

  /// 响应式成员变量
  final _page = 0.obs;
  get page => _page.value;

  @override
  void onInit() {
    print("onInit main");
    // handleInitialUri();
    // handleIncomingLinks();
    final Map<String, String?> allQuery = {};
    allQuery.addAll(Get.parameters);
    allQuery.addAll(Get.arguments ?? {});
    final tab = allQuery["tab"] ?? "home";
    _page.value = 0;
    if (tab == 'post') {
      _page.value = 1;
    } else if (tab == 'message') {
      _page.value = 2;
    }
    if (_page.value > 0 && !AuthProvider.to.isLogin) {
      // need login
      final query = Uri(queryParameters: Get.arguments).query;
      Get.offNamed(Routes.LOGIN, parameters: {
        "next": "${Routes.MAIN}${query.isNotEmpty ? '?' + query : ''}"
      });
    }
    pageController = PageController(initialPage: _page.value);
    super.onInit();
  }

  final isInit = false.obs;

  @override
  void onReady() {
    super.onReady();
  }

  // tab栏页码切换
  void handlePageChanged(int page) {
    if (page > 0 && !AuthProvider.to.isLogin) {
      // need login
      var tab = "message";
      if (page == 1) {
        tab = "post";
      }
      final allParam = {"tab": tab};
      allParam.addAll(Get.arguments ?? {});
      final query = Uri(queryParameters: allParam).query;
      Get.toNamed(Routes.LOGIN, parameters: {
        "next": "${Routes.MAIN}${query.isNotEmpty ? '?' + query : ''}"
      });
    } else {
      _page.value = page;
      BottomNavigationBarController.to.pageController.animateToPage(page,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    }
  }

  void changeBackgroundColor(String value) {
    if (value.isNotEmpty) {
      backgroundColor.value = value;
    }
  }

  @override
  void dispose() {
    uriSub?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
