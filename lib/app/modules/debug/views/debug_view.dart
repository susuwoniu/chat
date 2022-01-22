import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/config/config.dart';
import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:get/get.dart';
import '../controllers/debug_controller.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';

import 'package:chat/common.dart';

class DebugView extends GetView<DebugController> {
  final String countryCode = "+86";
  final String phone = "17955690865";

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
                  title: Text('Clear All'),
                  onTap: () async {
                    try {
                      if (AuthProvider.to.isLogin) {
                        await AccountProvider.to.handleLogout();
                      }
                      await CacheProvider.to.clear();
                      await AccountStoreProvider.to.clear();
                      await KVProvider.to.clear();
                      UIUtils.toast("Clear All Success");
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text('Home'),
                  onTap: () {
                    RouterProvider.to.toHome();
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
                        await AccountProvider.to.handleLogout();
                        RouterProvider.to.restart(context);
                        UIUtils.toast("退出成功");
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
                        final rooms = MessageController.to.initRooms();
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
                      try {
                        await AccountProvider.to
                            .handleSendCode(countryCode, phone);
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
                        RouterProvider.to.setNextPage(NextPage.back());
                        await AccountProvider.to.handleLogin(
                            countryCode, phone, '123456',
                            enabledDefaultNexPage: false);
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
                  title: Text('REPORT'),
                  onTap: () {
                    RouterProvider.to.switchTo(Routes.REPORT);
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('Message'),
                  onTap: () {
                    RouterProvider.to.toMessage();
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('Me'),
                  onTap: () {
                    RouterProvider.to.toMe();
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
                    Get.toNamed(Routes.TEST3, arguments: {'id': '1'});
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text('Splash'),
                  onTap: () {
                    Get.toNamed(
                      Routes.SPLASH,
                    );
                    //to close the drawer
                  },
                ),
                ListTile(
                  title: Text(
                    '测试服务器版本',
                  ),
                  onTap: () async {
                    try {
                      final response = await APIProvider.to
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
                      await AccountProvider.to.getMe();
                      UIUtils.toast('成功请求');
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '测试获取kv',
                  ),
                  onTap: () async {
                    try {
                      final result = KVProvider.to.getKeys();
                      Get.defaultDialog(
                          title: "结果", content: Text(result.toString()));
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '测试写入kv',
                  ),
                  onTap: () async {
                    try {
                      final result = await KVProvider.to
                          .setString('test_kv_key', "test value");
                      UIUtils.toast('result: $result');
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '测试获取cache store keys',
                  ),
                  onTap: () async {
                    try {
                      final result = CacheProvider.to.getKeys();
                      Get.defaultDialog(
                          title: "结果", content: Text(result.toString()));
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '测试写入cache store',
                  ),
                  onTap: () async {
                    try {
                      await CacheProvider.to
                          .setString('test_cache_key', "test value");
                      UIUtils.toast('yes');
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
                      final response =
                          await APIProvider.to.post("/post/post-templates");
                      // UIUtils.toast(response.bodyString);

                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '是否跳过看过的帖子? ${ConfigProvider.to.skipViewedPost.value}',
                  ),
                  onTap: () async {
                    try {
                      ConfigProvider.to.toggleSkipViewedPost();
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '打印数据库索引',
                  ),
                  onTap: () async {
                    try {
                      await ChatProvider.to.database!.printIndexee();
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '打印数据库结构',
                  ),
                  onTap: () async {
                    try {
                      await ChatProvider.to.database!.printTables();
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '打印最新5条数据库消息',
                  ),
                  onTap: () async {
                    try {
                      await ChatProvider.to.database!
                          .getMessages(limit: 20, sort: "desc");
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '打印服务端最新5条数据库消息',
                  ),
                  onTap: () async {
                    try {
                      await ChatProvider.to.roomManager!
                          .getServerMessages(limit: 5, sort: "desc");
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '打印本地的房间列表',
                  ),
                  onTap: () async {
                    try {
                      await ChatProvider.to.roomManager!.getAllRooms();
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
