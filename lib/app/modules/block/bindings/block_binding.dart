import 'package:get/get.dart';

import '../controllers/block_controller.dart';
import '../../other/controllers/other_controller.dart';

class BlockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherController>(
      () => OtherController(),
    );
    Get.lazyPut<BlockController>(
      () => BlockController(),
    );
  }
}
