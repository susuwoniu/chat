import 'package:get/get.dart';

import '../controllers/create_controller.dart';
import '../../post/controllers/post_controller.dart';

class CreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PostController>(
      PostController(),
    );
    Get.put<CreateController>(
      CreateController(),
    );
  }
}
