import 'package:get/get.dart';

import '../controllers/message_controller.dart';
import '../../main/controllers/bottom_navigation_bar_controller.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BottomNavigationBarController>(BottomNavigationBarController());
    Get.put<MessageController>(MessageController());
  }
}
