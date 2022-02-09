import 'package:get/get.dart';

import '../controllers/complete_age_controller.dart';
import '../../edit_info/controllers/edit_info_controller.dart';

class CompleteAgeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditInfoController>(
      () => EditInfoController(),
    );
    Get.lazyPut<CompleteAgeController>(
      () => CompleteAgeController(),
    );
  }
}
