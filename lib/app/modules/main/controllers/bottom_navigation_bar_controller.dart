import 'package:chat/common.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';

class BottomNavigationBarController extends GetxController {
  static BottomNavigationBarController get to => Get.find(); // add this line
  final backgroundColor = BACKGROUND_COLORS[0].value.obs;
  final frontColor = FRONT_COLORS[0].value.obs;
  // 页控制器
  late final PageController pageController;

  /// 响应式成员变量
  final _page = 0.obs;
  get page => _page.value;
  final _messageNotificationCount = 0.obs;
  get messageNotificationCount => _messageNotificationCount.value;
  @override
  void onInit() {
    print("onInit main");
    pageController = PageController(initialPage: page);
    changePageFromArguments(Get.arguments);
    super.onInit();
  }

  void setMessageNotificationCount(int count) {
    _messageNotificationCount.value = count;
  }

  void changePageFromArguments(dynamic arguments) {
    final Map<String, String?> allQuery = {};
    allQuery.addAll(arguments ?? {});
    final tab = allQuery["tab"] ?? "home";
    int? newPage;
    if (tab == 'message') {
      newPage = 1;
    } else if (tab == 'me') {
      newPage = 2;
    } else if (tab == 'home') {
      newPage = 0;
    }
    if (newPage != null) {
      handlePageChanged(newPage);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  // tab栏页码切换
  void handlePageChanged(int newPage) {
    if (newPage != page) {
      if (newPage > 0 && !AuthProvider.to.isLogin) {
        // need login
        var tab = "message";
        if (newPage == 2) {
          tab = "me";
        }
        final allParam = {
          "tab": tab,
        };
        allParam.addAll(Get.arguments ?? {});
        final query = Uri(queryParameters: allParam).query;
        Get.toNamed(Routes.LOGIN, arguments: {
          'mode': "switchTo",
          "next": "${Routes.MAIN}${query.isNotEmpty ? '?' + query : ''}"
        });
      } else {
        _page.value = newPage;
        pageController.animateToPage(newPage,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
      }
    }
  }

  void changeBackgroundColor(int value, int theFrontColor) {
    backgroundColor.value = value;
    frontColor.value = theFrontColor;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
