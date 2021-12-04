import 'package:get/get.dart';

import '../controllers/gender_view_controller.dart';

class GenderViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenderViewController>(
      () => GenderViewController(),
    );
  }
}
