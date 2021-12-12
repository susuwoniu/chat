import 'package:flutter/material.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:get/get.dart';

mainBottomNavigationBar(BuildContext context) {
  return Obx(() => BottomNavigationBar(
        currentIndex: BottomNavigationBarController.to.page,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.transparent,
        // backgroundColor: (BottomNavigationBarController.to.page > 0 ||
        //         BottomNavigationBarController.to.backgroundColor.value.isEmpty)
        //     ? Colors.transparent
        //     : Colors.transparent,
        onTap: (index) {
          BottomNavigationBarController.to.handlePageChanged(index);
        },
        items: [
          // _Paths.Main + [Empty]
          BottomNavigationBarItem(
              icon: Text("🔥", style: Theme.of(context).textTheme.headline5),
              label: 'Home'),
          // _Paths.Main + Routes.POST
          BottomNavigationBarItem(
            icon: Text("✍️", style: Theme.of(context).textTheme.headline5),
            label: 'Post',
          ),
          // _Paths.HOME + _Paths.MESSAGE
          BottomNavigationBarItem(
            icon: Text("👋", style: Theme.of(context).textTheme.headline5),
            label: 'Message',
          ),
        ],
      ));
}
