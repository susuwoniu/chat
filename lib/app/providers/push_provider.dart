import 'package:get/get.dart';
import 'package:chat/config/config.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import './router_provider.dart';
import '../routes/app_pages.dart';
import 'package:chat/common.dart';

class PushProvider extends GetxService {
  static PushProvider get to => Get.find();
  final JPush jpush = JPush();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  Future<void> onInit() async {
    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        // clear all
        // TODO
        jpush.clearAllNotifications();
        // clear local notification

        // parse extras
        // TODO ios
        if (message["extras"] != null) {
          if (message["extras"]["cn.jpush.android.EXTRA"] != null) {
            Map<String, dynamic> extra =
                jsonDecode(message["extras"]["cn.jpush.android.EXTRA"]);

            handleExtra(extra);
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

    // init local push

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    super.onInit();
  }

  void handleExtra(Map<String, dynamic> extra) {
    if (extra["url"] != null) {
      final targetUrl = extra["url"];
      final uri = Uri.parse(targetUrl);
      // open targetUrl
      final path = uri.path.isNotEmpty ? uri.path : Routes.MAIN;
      final query = uri.queryParameters.isNotEmpty ? uri.queryParameters : {};
      RouterProvider.to.setNextPage(
          NextPage(route: path, mode: NextMode.SwitchTo, arguments: query));
      RouterProvider.to.toNextPage();
    }
  }

  void selectNotification(String? payload) async {
    await flutterLocalNotificationsPlugin.cancelAll();

    if (payload != null) {
      Log.debug('notification payload: $payload');
      Map<String, dynamic> extra = jsonDecode(payload);
      handleExtra(extra);
    }
  }

  @override
  void onReady() async {
    super.onReady();
    // clear all notifications
    try {
      await PushProvider.to.jpush.getRegistrationID();
      await PushProvider.to.jpush.clearAllNotifications();
      await flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      print('get device token error: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
