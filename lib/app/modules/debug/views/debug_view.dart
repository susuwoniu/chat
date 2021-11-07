import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';

import 'package:get/get.dart';

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
      body: Obx(() => Column(
            children: [
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Get.toNamed(Routes.HOME);
                  //to close the drawer
                },
              ),
              ListTile(
                title: Text('Post'),
                onTap: () {
                  Get.toNamed(Routes.POST);
                  //to close the drawer
                },
              ),
              ListTile(
                title: Text('Message'),
                onTap: () {
                  Get.toNamed(Routes.MESSAGE);
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
                  Get.toNamed(Routes.TEST3);
                  //to close the drawer
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
            ],
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
