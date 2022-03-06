import 'package:get/get.dart';

import '../controllers/home_setting_controller.dart';

class HomeSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeSettingController>(
      () => HomeSettingController(),
    );
  }
}
