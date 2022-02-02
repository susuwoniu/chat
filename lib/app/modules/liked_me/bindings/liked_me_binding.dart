import 'package:get/get.dart';

import '../controllers/liked_me_controller.dart';
import '../../other/controllers/other_controller.dart';

class LikedMeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherController>(
      () => OtherController(),
    );
    Get.lazyPut<LikedMeController>(
      () => LikedMeController(),
    );
  }
}
