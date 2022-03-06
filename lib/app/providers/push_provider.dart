import 'package:get/get.dart';
import 'package:chat/config/config.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class PushProvider extends GetxService {
  static PushProvider get to => Get.find();
  final JPush jpush = JPush();
  @override
  void onInit() {
    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
      });
    } catch (e) {
      print("add event handler error: $e");
    }
    jpush.setup(
      appKey: AppConfig().config.jiguangAppKey, //你自己应用的 AppKey
      channel: "main",
      // todo
      production: false,
      debug: true,
    );

// init push

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
