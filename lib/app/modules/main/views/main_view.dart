import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chat/app/modules/home/views/home_view.dart';
import 'package:chat/app/modules/post/views/post_view.dart';

import 'package:chat/app/modules/message/views/message_view.dart';

class MainView extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    final bottomNavigationBarController = BottomNavigationBarController.to;
    final backgroundColor = bottomNavigationBarController.backgroundColor;
    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.page,
            backgroundColor:
                (controller.page > 0 || backgroundColor.value.isEmpty)
                    ? null
                    : HexColor(backgroundColor.value),
            onTap: (index) {
              controller.page = index;
              controller.pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease);
            },
            items: [
              // _Paths.Main + [Empty]
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              // _Paths.Main + Routes.POST
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box_rounded),
                label: 'Post',
              ),
              // _Paths.HOME + _Paths.MESSAGE
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box_rounded),
                label: 'Message',
              ),
            ],
          )),
    );
  }

  // 内容页
  Widget _buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[HomeView(), PostView(), MessageView()],
      controller: controller.pageController,
      onPageChanged: controller.handlePageChanged,
    );
  }
}
