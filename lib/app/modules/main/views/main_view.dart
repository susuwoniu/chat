import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/modules/main/controllers/main_controller.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:hexcolor/hexcolor.dart';

class MainView extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        //This router outlet handles the appbar and the bottom navigation bar
        final currentLocation = currentRoute?.location;

        var currentIndex = 0;
        if (currentLocation?.startsWith(Routes.ROOT) == true) {
          currentIndex = 0;
        }
        if (currentLocation?.startsWith(Routes.POST) == true) {
          currentIndex = 1;
        }

        if (currentLocation?.startsWith(Routes.MESSAGE) == true) {
          currentIndex = 2;
        }
        final bottomNavigationBarController = BottomNavigationBarController.to;
        final backgroundColor = bottomNavigationBarController.backgroundColor;
        return Scaffold(
            body: GetRouterOutlet(
              initialRoute: Routes.HOME,
              key: Get.nestedKey(Routes.MAIN),
            ),
            bottomNavigationBar: Obx(() => BottomNavigationBar(
                  currentIndex: currentIndex,
                  backgroundColor:
                      (currentIndex > 0 || backgroundColor.value.isEmpty)
                          ? null
                          : HexColor(backgroundColor.value),
                  onTap: (value) {
                    switch (value) {
                      case 0:
                        delegate.toNamed(Routes.HOME);
                        break;
                      case 1:
                        delegate.toNamed(Routes.POST);
                        break;
                      case 2:
                        delegate.toNamed(Routes.MESSAGE);
                        break;
                      default:
                    }
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
                )));
      },
    );
  }
}
