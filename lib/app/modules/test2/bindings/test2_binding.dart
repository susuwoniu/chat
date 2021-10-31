import 'package:get/get.dart';

import '../controllers/test2_controller.dart';

class Test2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Test2Controller>(
      () => Test2Controller(),
    );
  }
}
