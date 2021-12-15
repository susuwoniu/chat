import 'package:get/get.dart';

import '../controllers/test3_controller.dart';

class Test3Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<Test3Controller>(
      Test3Controller(),
    );
  }
}
