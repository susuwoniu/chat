import 'package:get/get.dart';
import 'package:chat/config/config.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'dart:convert';
import './router_provider.dart';
import '../routes/app_pages.dart';

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
        // clear all
        // TODO
        jpush.clearAllNotifications();
        // parse extras
        // TODO ios
        if (message["extras"] != null) {
          if (message["extras"]["cn.jpush.android.EXTRA"] != null) {
            Map<String, dynamic> extra =
                jsonDecode(message["extras"]["cn.jpush.android.EXTRA"]);

            if (extra["url"] != null) {
              final targetUrl = extra["url"];
              final uri = Uri.parse(targetUrl);
              // open targetUrl
              final path = uri.path.isNotEmpty ? uri.path : Routes.MAIN;
              final query =
                  uri.queryParameters.isNotEmpty ? uri.queryParameters : {};
              RouterProvider.to.setNextPage(NextPage(
                  route: path, mode: NextMode.SwitchTo, arguments: query));
              RouterProvider.to.toNextPage();
            }
          }
        }
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
      production: !AppConfig.to.isDev,
      debug: AppConfig.to.isDev,
    );

// init push

    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    // clear all notifications
    try {
      await PushProvider.to.jpush.getRegistrationID();
      await PushProvider.to.jpush.clearAllNotifications();
    } catch (e) {
      print('get device token error: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
