import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(
      () => MessageController(),
    );
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
  }
}
