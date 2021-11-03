import 'package:get/get.dart';

import '../controllers/test3_controller.dart';

class Test3Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Test3Controller>(
      () => Test3Controller(),
    );
  }
}
