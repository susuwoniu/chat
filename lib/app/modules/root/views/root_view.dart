import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/root_controller.dart';
import '../../splash/views/splash_view.dart';
import '../../main/views/main_view.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isInit.isFalse) {
        return SplashView();
      } else {
        return MainView();
      }
    });
  }
}
