import 'package:get/get.dart';

import '../controllers/create_controller.dart';
import '../../post/controllers/post_controller.dart';

class CreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostController>(
      () => PostController(),
    );
    Get.lazyPut<CreateController>(
      () => CreateController(),
    );
  }
}
