import 'package:flutter/material.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';

mainBottomNavigationBar() {
  return Obx(() => BottomNavigationBar(
        currentIndex: BottomNavigationBarController.to.page,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // backgroundColor: (BottomNavigationBarController.to.page > 0 ||
        //         BottomNavigationBarController.to.backgroundColor.value.isEmpty)
        //     ? Colors.transparent
        //     : Colors.transparent,
        onTap: (index) {
          BottomNavigationBarController.to.page = index;
          BottomNavigationBarController.to.pageController.animateToPage(index,
              duration: const Duration(milliseconds: 200), curve: Curves.ease);
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
      ));
}
