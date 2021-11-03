import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/root_controller.dart';
import 'drawer.dart';
import '../../splash/views/splash_view.dart';
import '../../test2/views/test2_view.dart';
import '../../main/views/main_view.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(builder: (context, delegate, current) {
      final title = current?.location;

      return Obx(() {
        if (controller.isInit.isFalse) {
          return SplashView();
        } else {
          return MainView();
          // return Scaffold(
          //     // drawer: DrawerWidget(),
          //     // appBar: AppBar(
          //     //   title: Text(title ?? ''),
          //     //   centerTitle: true,
          //     // ),
          //     body: GetRouterOutlet(
          //   initialRoute: Routes.TEST2,
          //   anchorRoute: '/',
          //   // filterPages: (afterAnchor) {
          //   //   return afterAnchor.take(1);
          //   // },
          // ));
        }
      });
    });
  }
}
