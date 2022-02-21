import 'package:get/get.dart';

import '../controllers/explore_controller.dart';
import '../../post/controllers/post_controller.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreController>(
      () => ExploreController(),
    );
    Get.lazyPut<PostController>(
      () => PostController(),
    );
  }
}
