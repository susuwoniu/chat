import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:chat/app/modules/home/views/home_view.dart';
import 'package:chat/app/modules/me/views/me_view.dart';
import 'package:chat/app/modules/message/views/message_view.dart';
import 'package:chat/app/widgets/main_bottom_navigation_bar.dart';

class MainView extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: _buildPageView(),
        bottomNavigationBar: mainBottomNavigationBar(context));
  }

  // 内容页
  Widget _buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[HomeView(), MessageView(), MeView()],
      controller: BottomNavigationBarController.to.pageController,
    );
  }
}
