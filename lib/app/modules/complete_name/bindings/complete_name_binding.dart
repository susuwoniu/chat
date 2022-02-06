import 'package:get/get.dart';

import '../controllers/complete_name_controller.dart';

class CompleteNameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteNameController>(
      () => CompleteNameController(),
    );
  }
}
