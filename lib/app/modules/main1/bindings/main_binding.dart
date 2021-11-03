import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import '../controllers/bottom_navigation_bar_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<BottomNavigationBarController>(
      () => BottomNavigationBarController(),
    );
  }
}
