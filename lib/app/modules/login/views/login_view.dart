import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import '../controllers/login_controller.dart';
import 'package:chat/common.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login_title'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () {
                final isLoggedIn = AuthProvider.to.isLogin;
                return Text(
                  '当前登录状态'
                  ' ${isLoggedIn ? "已登陆" : "未登录"}'
                  "\nIt's impossible to enter this "
                  "route when you are logged in!",
                );
              },
            ),
            MaterialButton(
                child: Text(
                  '发送验证码',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                onPressed: () async {
                  try {
                    await controller.handleSendCode();
                    UIUtils.toast('验证码发送成功');
                  } catch (e) {}
                }),
            MaterialButton(
                child: Text(
                  '点击登录 !!',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                onPressed: () async {
                  try {
                    await controller.handleLogin();
                    UIUtils.toast('登录成功');
                  } catch (e) {
                    UIUtils.showError(e);
                  }
                }),
            MaterialButton(
                child: Text(
                  '测试请求 !!',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                onPressed: () async {
                  try {
                    await controller.getMe();
                    UIUtils.toast('成功请求');
                  } catch (e) {
                    UIUtils.showError(e);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
