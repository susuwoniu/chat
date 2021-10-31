import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/start_controller.dart';
import '../../splash/views/splash_view.dart';
import "../../home/views/home_view.dart";

class StartView extends GetView<StartController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: controller.isInit.isFalse ? SplashView() : HomeView(),
        ));
  }
}
