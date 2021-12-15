import 'package:get/get.dart';

import '../controllers/debug_controller.dart';
import 'package:chat/app/modules/login/controllers/login_controller.dart';

class DebugBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DebugController>(
      () => DebugController(),
    );
  }
}
