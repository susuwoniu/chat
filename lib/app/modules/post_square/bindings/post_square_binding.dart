import 'package:get/get.dart';

import '../controllers/post_square_controller.dart';

class PostSquareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostSquareController>(
      () => PostSquareController(),
    );
  }
}
