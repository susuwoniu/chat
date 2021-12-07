import 'package:get/get.dart';

import '../controllers/add_profile_image_controller.dart';

class AddProfileImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddProfileImageController>(
      () => AddProfileImageController(),
    );
  }
}
