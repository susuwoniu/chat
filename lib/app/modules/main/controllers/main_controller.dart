import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

class MainController extends GetxController {
  MainController();

  /// 响应式成员变量
  final _page = 0.obs;
  set page(value) => _page.value = value;
  get page => _page.value;

  /// 成员变量

  // tab 页标题
  late final List<String> tabTitles;

  // 页控制器
  late final PageController pageController;

  // 底部导航项目
  late final List<BottomNavigationBarItem> bottomTabs;

  /// 事件

  // tab栏动画
  void handleNavBarTap(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  // tab栏页码切换
  void handlePageChanged(int page) {
    _page.value = page;
  }

  /// scheme 内部打开
  bool isInitialUriIsHandled = false;
  StreamSubscription? uriSub;

  // 第一次打开
  Future<void> handleInitialUri() async {
    if (!isInitialUriIsHandled) {
      isInitialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          // 这里获取了 scheme 请求
          print('got initial uri: $uri');
        }
      } on PlatformException {
        print('falied to get initial uri');
      } on FormatException catch (err) {
        print('malformed initial uri, ' + err.toString());
      }
    }
  }

  // 程序打开时介入
  void handleIncomingLinks() {
    if (!kIsWeb) {
      uriSub = uriLinkStream.listen((Uri? uri) {
        // 这里获取了 scheme 请求
        print('got uri: $uri');
      }, onError: (Object err) {
        print('got err: $err');
      });
    }
  }

  /// 生命周期

  @override
  void onInit() {
    super.onInit();

    // handleInitialUri();
    // handleIncomingLinks();

    pageController = PageController(initialPage: _page.value);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    uriSub?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
