import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class BottomNavigationBarController extends GetxController {
  static BottomNavigationBarController get to => Get.find(); // add this line
  final backgroundColor = RxString("");
  // 页控制器
  late final PageController pageController;
  StreamSubscription? uriSub;

  /// scheme 内部打开
  bool isInitialUriIsHandled = false;

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

  /// 响应式成员变量
  final _page = 0.obs;
  set page(value) => _page.value = value;
  get page => _page.value;

  @override
  void onInit() {
    super.onInit();

    // handleInitialUri();
    // handleIncomingLinks();

    pageController = PageController(initialPage: _page.value);
  }

  final isInit = false.obs;

  @override
  void onReady() {
    super.onReady();
  }

  // tab栏页码切换
  void handlePageChanged(int page) {
    _page.value = page;
  }

  @override
  void onClose() {}
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
