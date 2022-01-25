import 'package:get/get.dart';

import '../controllers/block_controller.dart';
import '../../profile_viewers/controllers/profile_viewers_controller.dart';

class BlockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlockController>(
      () => BlockController(),
    );
    Get.put<ProfileViewersController>(
      ProfileViewersController(),
    );
  }
}
