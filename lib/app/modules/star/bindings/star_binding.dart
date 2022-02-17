import 'package:get/get.dart';

import '../controllers/star_controller.dart';

class StarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StarController>(
      StarController(),
    );
  }
}
