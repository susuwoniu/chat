import 'package:get/get.dart';

import '../controllers/age_picker_controller.dart';
import '../../edit_info/controllers/edit_info_controller.dart';

class AgePickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditInfoController>(
      () => EditInfoController(),
    );
    Get.lazyPut<AgePickerController>(
      () => AgePickerController(),
    );
  }
}
