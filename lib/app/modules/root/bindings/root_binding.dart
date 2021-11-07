import 'package:get/get.dart';

import '../controllers/root_controller.dart';
import 'package:chat/app/modules/main/bindings/main_binding.dart';

import 'package:chat/app/modules/splash/bindings/splash_binding.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
    MainBinding().dependencies();
    SplashBinding().dependencies();
  }
}
