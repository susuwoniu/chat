import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:chat/common.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:chat/global.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class RouterProvider extends GetxService {
  static RouterProvider get to => Get.find();

  /// scheme 内部打开
  bool isInitialUriIsHandled = false;
  StreamSubscription? uriSub;
  NextPage? _nextPage;
  NextPage? get nextPage => _nextPage;
  int closePageCountBeforeNextPage = 0;
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
        final path = uri.path.isNotEmpty ? uri.path : Routes.MAIN;
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
    if (route == Routes.MAIN) {
      BottomNavigationBarController.to.changePageFromArguments(arguments);
      Get.until((route) {
        return route.settings.name == Routes.MAIN;
      });
    } else {
      Get.offNamedUntil(route, (route) {
        return route.settings.name == Routes.MAIN;
      }, arguments: arguments);
    }
  }

  Future<void> restart(BuildContext context) async {
    // reset current app state
    // await Get.deleteAll(force: true);
    // Get.reset();
    Get.reset();
    // Get.reloadAll(force: true);

    //any Get.put will be deleted. you need to re Get.put any dependency that is required at startup
    await Global.initGetx();
    AppPages.history.clear();
    Phoenix.rebirth(context);

    //to remove the current route you have to first navigate to an empty page, so the route stack is completely empty.
    // Get.offAllNamed(Routes.SPLASH);

    //this is the route that loads as startup page
    // Get.offAllNamed(Routes.ROOT);
  }

  void toNextAction(ActionEntity action, {required bool isLastAction}) {
    final actionType = action.type;
    if (actionType == 'agree_community_rules') {
      Get.toNamed(Routes.RULE, arguments: {
        "content": action.content,
        "is-last-action": isLastAction.toString(),
      });
    } else if (actionType == 'add_account_birthday') {
      Get.toNamed(Routes.COMPLETE_AGE, arguments: {
        "is-last-action": isLastAction.toString(),
      });
    } else if (actionType == 'add_account_gender') {
      Get.toNamed(Routes.COMPLETE_GENDER, arguments: {
        "is-last-action": isLastAction.toString(),
      });
    } else if (actionType == 'add_account_name') {
      Get.toNamed(Routes.COMPLETE_NAME, arguments: {
        "is-last-action": isLastAction.toString(),
      });
    } else if (actionType == 'add_account_bio') {
      Get.toNamed(Routes.COMPLETE_BIO, arguments: {
        "is-last-action": isLastAction.toString(),
      });
    } else if (actionType == 'add_account_avatar') {
      Get.toNamed(Routes.COMPLETE_AVATAR, arguments: {
        "is-last-action": isLastAction.toString(),
      });
    } else {
      if (_nextPage != null) {
        toNextPage();
      } else {
        toHome();
      }
    }
  }

  void toNextPageOrHome() {
    if (_nextPage != null) {
      toNextPage();
    } else {
      toHome();
    }
  }

  void toNextPage() {
    // 检测 next 参数，如果有，则跳转到next参数页面，没有则跳转到首页
    final next = _nextPage;
    if (next != null) {
      _nextPage = null;

      if (closePageCountBeforeNextPage > 0) {
        Get.close(closePageCountBeforeNextPage);
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
    closePageCountBeforeNextPage = count;
  }

  void handleNextPageArguments(dynamic arguments) {
    if (arguments != null) {
      final data = arguments as Map<String, dynamic>;
      if (data['next'] != null) {
        RouterProvider.to.setNextPage(NextPage.fromArguments(arguments));
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
  NextPage({
    required this.route,
    this.arguments,
    required this.mode,
  });
  static NextPage fromDefault() {
    return NextPage(
      route: Routes.MAIN,
      arguments: null,
      mode: NextMode.SwitchTo,
    );
  }

  static NextPage back() {
    return NextPage(
      route: Routes.ROOT,
      arguments: null,
      mode: NextMode.Back,
    );
  }

  static NextPage fromArguments(Map<dynamic, dynamic> arguments) {
    final nextPage = arguments['next'];
    final nextPageMode = arguments['mode'];
    if (nextPage == null && nextPageMode == null) {
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

    return NextPage(
      route: nextRoute,
      arguments: nextArguments,
      mode: nextMode,
    );
  }

  Map<String, String> toArguments() {
    final nextUri = Uri(
        path: route, queryParameters: argumentsToQueryParameters(arguments));
    return <String, String>{
      'next': nextUri.toString(),
      'mode': camel(mode.toString().toLowerCase()),
    };
  }
}

String camel(String s) => s[0].toLowerCase() + s.substring(1);
argumentsToQueryParameters(Map<String, dynamic>? arguments) {
  final queryParameters = <String, String>{};
  if (arguments != null) {
    arguments.forEach((key, value) {
      queryParameters[key] = value.toString();
    });
  }

  return queryParameters;
}
