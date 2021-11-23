import 'package:get/get.dart';

import '../controllers/message_controller.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MessageController>(MessageController());
  }
}
