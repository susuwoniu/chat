import 'package:get/get.dart';

import '../controllers/gender_select_controller.dart';

class GenderSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenderSelectController>(
      () => GenderSelectController(),
    );
  }
}
