import 'package:get/get.dart';

import '../controllers/change_gender_controller.dart';
import '../../edit_info/controllers/edit_info_controller.dart';

class ChangeGenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditInfoController>(
      () => EditInfoController(),
    );
    Get.lazyPut<ChangeGenderController>(
      () => ChangeGenderController(),
    );
  }
}
