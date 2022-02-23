import 'package:get/get.dart';

import '../controllers/room_controller.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';
import 'package:chat/app/modules/home/controllers/home_controller.dart';
import 'package:chat/app/modules/other/controllers/other_controller.dart';

class RoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(
      () => MessageController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.put<RoomController>(
      RoomController(),
    );
    Get.put<OtherController>(
      OtherController(),
    );
  }
}
