import 'package:get/get.dart';

import '../controllers/edit_input_controller.dart';

class EditInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditInputController>(
      () => EditInputController(),
    );
  }
}
