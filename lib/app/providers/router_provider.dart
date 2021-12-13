import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:chat/common.dart';
import 'package:chat/app/routes/app_pages.dart';

// class NextPage {
//   final String route;
//   final String arguments;
//   NextPage({this.route, this.arguments});
// }
class RouterProvider extends GetxService {
  static RouterProvider get to => Get.find();

  /// scheme 内部打开
  bool isInitialUriIsHandled = false;
  StreamSubscription? uriSub;
  String? _nextPage;
  String? _nextPageAction;
  int _closePageCountBeforeNextPage = 0;
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

  void toNextPage() {
    // 检测 next 参数，如果有，则跳转到next参数页面，没有则跳转到首页
    final next = _nextPage;
    final currentNextPageAction = _nextPageAction;
    final currentClosePageCountBeforeNextPage = _closePageCountBeforeNextPage;
    if (currentClosePageCountBeforeNextPage > 0) {
      setClosePageCountBeforeNextPage(0);
      Get.close(currentClosePageCountBeforeNextPage);
    }
    if (_nextPageAction != null || next != null) {
      setNextPage(null);
      setNextPageAction(null);
      final defaultAction =
          next != null && next == Routes.MAIN ? "offAll" : "off";
      final action = currentNextPageAction ?? defaultAction;
      if (action == 'offAll' && next != null) {
        // offAll must root
        // TODO ,root需要做一个路由中心
        Get.offAllNamed(Routes.ROOT);
      } else if (action == 'back') {
        Get.back();
      } else if (next != null && action == 'off') {
        Get.toNamed(next);
      }
    }
  }

  void setNextPage(String? nextPage) {
    _nextPage = nextPage;
  }

  void setNextPageAction(String? nextPageAction) {
    _nextPageAction = nextPageAction;
  }

  void setClosePageCountBeforeNextPage(int count) {
    _closePageCountBeforeNextPage = count;
  }

  int get closePageCountBeforeNextPage => _closePageCountBeforeNextPage;
}
