import 'package:get/get.dart';

import '../controllers/liked_me_controller.dart';

class LikedMeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikedMeController>(
      () => LikedMeController(),
    );
  }
}
