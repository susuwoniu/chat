import 'package:get/get.dart';

import '../controllers/complete_gender_controller.dart';

class CompleteGenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteGenderController>(
      () => CompleteGenderController(),
    );
  }
}
