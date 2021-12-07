import 'package:get/get.dart';

import '../controllers/gender_select_controller.dart';
import '../../edit_info/controllers/edit_info_controller.dart';

class GenderSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditInfoController>(
      () => EditInfoController(),
    );
    Get.lazyPut<GenderSelectController>(
      () => GenderSelectController(),
    );
  }
}
