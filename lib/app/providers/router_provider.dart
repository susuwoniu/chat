import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:chat/common.dart';

class RouterProvider extends GetxService {
  static RouterProvider get to => Get.find();

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
      } catch (e) {
        report(e);
      }
    }
  }

  // 程序打开时介入
  void handleIncomingLinks() {
    uriSub = linkStream.listen((String? uri) {
      // 这里获取了 scheme 请求
      print('got uri: $uri');
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
}
