import 'package:get/get.dart';

import '../controllers/rule_controller.dart';

class RuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RuleController>(
      () => RuleController(),
    );
  }
}
