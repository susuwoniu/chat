import 'package:get/get.dart';

import '../controllers/create_controller.dart';
import '../../post/controllers/post_controller.dart';
import '../../home/controllers/home_controller.dart';

class CreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(
      HomeController(),
    );
    Get.put<PostController>(
      PostController(),
    );
    Get.put<CreateController>(
      CreateController(),
    );
  }
}
