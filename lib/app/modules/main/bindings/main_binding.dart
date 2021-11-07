import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import '../controllers/bottom_navigation_bar_controller.dart';
import '../../message/bindings/message_binding.dart';
import '../../post/bindings/post_binding.dart';
import '../../home/bindings/home_binding.dart';

class MainBinding extends Bindings {
  static MainBinding get to => Get.find(); // add this line

  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.put<BottomNavigationBarController>(
      BottomNavigationBarController(),
    );
    HomeBinding().dependencies();
    PostBinding().dependencies();
    MessageBinding().dependencies();
  }
}
