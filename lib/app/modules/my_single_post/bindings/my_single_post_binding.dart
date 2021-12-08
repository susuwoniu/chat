import 'package:get/get.dart';

import '../controllers/my_single_post_controller.dart';

class MySinglePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MySinglePostController>(
      MySinglePostController(),
    );
  }
}
