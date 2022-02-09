import 'package:get/get.dart';

import '../controllers/complete_avatar_controller.dart';

class CompleteAvatarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteAvatarController>(
      () => CompleteAvatarController(),
    );
  }
}
