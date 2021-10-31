import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        //This router outlet handles the appbar and the bottom navigation bar
        final currentLocation = currentRoute?.location;
        var currentIndex = 0;
        if (currentLocation?.startsWith(Routes.MESSAGE) == true) {
          currentIndex = 2;
        }
        if (currentLocation?.startsWith(Routes.POST) == true) {
          currentIndex = 1;
        }
        return Scaffold(
          body: GetRouterOutlet(
            initialRoute: Routes.HOME,
            key: Get.nestedKey(Routes.MAIN),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
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
              // _Paths.HOME + [Empty]
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              // _Paths.HOME + Routes.POST
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
          ),
        );
      },
    );
  }
}
