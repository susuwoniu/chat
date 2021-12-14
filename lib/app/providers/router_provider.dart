import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:chat/common.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class RouterProvider extends GetxService {
  static RouterProvider get to => Get.find();

  /// scheme 内部打开
  bool isInitialUriIsHandled = false;
  StreamSubscription? uriSub;
  NextPage? _nextPage;
  NextPage? get nextPage => _nextPage;
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
          final path = uri.path.isNotEmpty ? uri.path : '/';
          final query =
              uri.queryParameters.isNotEmpty ? uri.queryParameters : {};
          setNextPage(
              NextPage(route: path, mode: NextMode.To, arguments: query));
        }
      } catch (e) {
        report(e);
      }
    }
  }

  // 程序打开时介入
  void handleIncomingLinks() {
    uriSub = uriLinkStream.listen((Uri? uri) {
      // 这里获取了 scheme 请求
      Log.debug('got uri: $uri');
      if (uri != null) {
        final path = uri.path.isNotEmpty ? uri.path : '/';
        final query = uri.queryParameters.isNotEmpty ? uri.queryParameters : {};
        setNextPage(
            NextPage(route: path, mode: NextMode.SwitchTo, arguments: query));
        toNextPage();
      }
    }, onError: (Object err) {
      report(err);
    });
  }

  @override
  void onInit() {
    handleInitialUri();
    handleIncomingLinks();
    super.onInit();
  }

  @override
  void onClose() {
    uriSub?.cancel();
    super.onClose();
  }

  void toHome() {
    Get.until((route) {
      return route.settings.name == Routes.MAIN;
    });
  }

  void toMessage() {
    BottomNavigationBarController.to.handlePageChanged(1);
    Get.until((route) {
      return route.settings.name == Routes.MAIN;
    });
  }

  void toMe() {
    BottomNavigationBarController.to.handlePageChanged(2);
    Get.until((route) {
      return route.settings.name == Routes.MAIN;
    });
  }

  void switchTo(String route, {dynamic arguments}) {
    Get.offNamedUntil(route, (route) {
      return route.settings.name == Routes.MAIN;
    }, arguments: arguments);
  }

  void restart(BuildContext context) {
    Phoenix.rebirth(context);
  }

  void toNextPage() {
    // 检测 next 参数，如果有，则跳转到next参数页面，没有则跳转到首页
    final next = _nextPage;
    if (next != null) {
      _nextPage = null;

      if (next.closePageCountBeforeNextPage > 0) {
        Get.close(next.closePageCountBeforeNextPage);
      }
      final mode = next.mode;

      if (mode == NextMode.OffAll) {
        // offAll must root
        Get.offAllNamed(next.route, arguments: next.arguments);
      } else if (mode == NextMode.SwitchTo) {
        switchTo(next.route, arguments: next.arguments);
      } else if (mode == NextMode.Back) {
        Get.back();
      } else if (mode == NextMode.To) {
        Get.toNamed(next.route, arguments: next.arguments);
      } else if (mode == NextMode.Off) {
        Get.offNamed(next.route, arguments: next.arguments);
      }
    }
  }

  void setNextPage(NextPage? nextPage) {
    _nextPage = nextPage;
  }

  void setClosePageCountBeforeNextPage(int count) {
    _nextPage?.closePageCountBeforeNextPage = count;
  }

  void handleNextPageArguments() {
    if (Get.arguments != null) {
      final data = Get.arguments as Map<String, dynamic>;
      if (data['next'] != null) {
        RouterProvider.to.setNextPage(NextPage.fromArguments(Get.arguments));
      } else if (data['mode'] != null && data['mode'] == 'back') {
        RouterProvider.to.setNextPage(NextPage.back());
      }
    }
  }

  void handleNextPageDipose() {
    setNextPage(null);
  }
}

enum NextMode { To, Off, OffAll, Back, SwitchTo }

class NextPage {
  String route;
  dynamic arguments;
  NextMode mode;
  int closePageCountBeforeNextPage;
  NextPage(
      {required this.route,
      this.arguments,
      required this.mode,
      this.closePageCountBeforeNextPage = 0});
  static NextPage fromDefault() {
    return NextPage(
      route: Routes.MAIN,
      arguments: null,
      mode: NextMode.SwitchTo,
      closePageCountBeforeNextPage: 0,
    );
  }

  static NextPage back() {
    return NextPage(
      route: Routes.ROOT,
      arguments: null,
      mode: NextMode.Back,
      closePageCountBeforeNextPage: 0,
    );
  }

  static NextPage fromArguments(Map<String, dynamic> arguments) {
    final nextPage = arguments['next'];
    final nextPageMode = arguments['mode'];
    if (nextPage == null || nextPageMode == null) {
      return NextPage.fromDefault();
    }
    final nextPageUri = Uri.parse(nextPage);
    final nextRoute = nextPageUri.path;
    final nextArguments = nextPageUri.queryParameters;
    final nextMode = nextPageMode == 'to'
        ? NextMode.To
        : nextPageMode == 'off'
            ? NextMode.Off
            : NextMode.SwitchTo;
    final closePageCountBeforeNextPageValue =
        arguments['closePageCountBeforeNextPage'];
    final closePageCountBeforeNextPage =
        closePageCountBeforeNextPageValue == null
            ? 0
            : int.parse(closePageCountBeforeNextPageValue);

    return NextPage(
        route: nextRoute,
        arguments: nextArguments,
        mode: nextMode,
        closePageCountBeforeNextPage: closePageCountBeforeNextPage);
  }

  Map<String, String> toArguments() {
    final nextUri = Uri(path: route, queryParameters: arguments);
    return <String, String>{
      'next': nextUri.toString(),
      'mode': camel(mode.toString().toLowerCase()),
      'closePageCountBeforeNextPage': closePageCountBeforeNextPage.toString()
    };
  }
}

String camel(String s) => s[0].toLowerCase() + s.substring(1);
