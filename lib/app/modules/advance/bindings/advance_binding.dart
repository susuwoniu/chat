import 'package:get/get.dart';

import '../controllers/advance_controller.dart';

class AdvanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdvanceController>(
      () => AdvanceController(),
    );
  }
}
