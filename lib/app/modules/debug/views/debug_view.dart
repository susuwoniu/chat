import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/config/config.dart';
import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:get/get.dart';
import 'package:xmpp_stone/xmpp_stone.dart';
import '../controllers/debug_controller.dart';
import 'package:chat/app/modules/login/controllers/login_controller.dart';
import 'package:chat/common.dart';

class DebugView extends GetView<DebugController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DebugView'),
        centerTitle: true,
      ),
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text('Home'),
                  onTap: () {
                    Get.offAllNamed(Routes.MAIN);
                    //to close the drawer
                  },
                ),
                if (AuthProvider.to.isLogin)
                  ListTile(
                    title: Text(
                      'Account ID: ${AuthProvider.to.accountId}',
                    ),
                    onTap: () async {
                      // copy
                      await FlutterClipboard.copy(
                          AuthProvider.to.accountId ?? "");
                      UIUtils.toast("已复制");
                    },
                  ),
                if (AuthProvider.to.isLogin)
                  ListTile(
                    title: Text(
                      '退出登录',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () async {
                      try {
                        await LoginController.to.handleLogout();
                        UIUtils.toast("退出成功");
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    },
                  ),
                if (AuthProvider.to.isLogin)
                  ListTile(
                    title: Text(
                      '删除access_token',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () async {
                      try {
                        await LoginController.to.handleCleanAccessToken();
                        UIUtils.toast("删除成功");
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    },
                  ),
                if (AuthProvider.to.isLogin)
                  ListTile(
                    title: Text(
                      '获取聊天收件箱',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () async {
                      try {
                        final inboxManager = ChatProvider.to.inboxManager;
                        final rooms = await inboxManager!.queryAll();
                        print("rooms $rooms");
                        UIUtils.toast("发送请求成功");
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    },
                  ),
                if (!AuthProvider.to.isLogin)
                  ListTile(
                    title: Text(
                      '登录',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {
                      Get.toNamed(Routes.LOGIN);
                      //to close the drawer
                    },
                  ),
                if (!AuthProvider.to.isLogin)
                  ListTile(
                    title: Text(
                      '快捷获取验证码',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () async {
                      LoginController.to.setCountryCode("+86");
                      LoginController.to
                          .setPhoneNumber("+8615578875692", "+86");
                      try {
                        await LoginController.to.handleSendCode();
                        UIUtils.toast("发送成功");
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                      // Get.toNamed(Routes.LOGIN);
                      //to close the drawer
                    },
                  ),
                if (!AuthProvider.to.isLogin)
                  ListTile(
                    title: Text(
                      '快捷登录测试号',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () async {
                      UIUtils.showLoading();
                      try {
                        LoginController.to.setVerificationCode("123456");
                        await LoginController.to.handleLogin();
                        UIUtils.hideLoading();

                        UIUtils.toast("登录成功");
                      } catch (e) {
                        UIUtils.hideLoading();
                        UIUtils.showError(e);
                      }
                      //to close the drawer
                    },
                  ),
                ListTile(
                  title: Text('Post'),
                  onTap: () {
                    Get.offAllNamed(Routes.MAIN, arguments: {'tab': 'post'});
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('Message'),
                  onTap: () {
                    Get.offAllNamed(Routes.MAIN, arguments: {'tab': 'message'});
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('Settings'),
                  onTap: () {
                    Get.toNamed(Routes.SETTING);
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('Room'),
                  onTap: () {
                    Get.toNamed(Routes.ROOM);
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('splash'),
                  onTap: () {
                    Get.toNamed(Routes.SPLASH);
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('Test1'),
                  onTap: () {
                    Get.toNamed(Routes.TEST1);
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('Test2'),
                  onTap: () {
                    Get.toNamed(Routes.TEST2);
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('Test3'),
                  onTap: () {
                    Get.toNamed(Routes.TEST3, parameters: {'id': '1'});
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('clear'),
                  onTap: () {
                    KVProvider.to.clear();
                  },
                ),
                ListTile(
                  title: Text(
                    '测试服务器版本',
                  ),
                  onTap: () async {
                    try {
                      final response = await APIProvider.instance
                          .raw_request(AppConfig().config.apiHost, "GET");
                      // UIUtils.toast(response.bodyString);
                      JsonEncoder encoder = JsonEncoder.withIndent('  ');
                      Get.defaultDialog(
                          title: "结果",
                          content: Text(encoder.convert(response.body)));
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '测试请求Me',
                  ),
                  onTap: () async {
                    try {
                      await LoginController.to.getMe();
                      UIUtils.toast('成功请求');
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '测试错误请求',
                  ),
                  onTap: () async {
                    try {
                      final response = await APIProvider.instance
                          .post("/post/post-templates");
                      // UIUtils.toast(response.bodyString);

                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      default:
        break;
    }
  }
}
