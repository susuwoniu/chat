import 'package:get/get.dart';
import '../../post/controllers/post_controller.dart';

import '../controllers/post_square_controller.dart';

class PostSquareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostSquareController>(
      () => PostSquareController(),
    );
    Get.put<PostController>(
      PostController(),
    );
  }
}
