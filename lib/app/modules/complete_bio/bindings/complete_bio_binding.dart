import 'package:get/get.dart';

import '../controllers/complete_bio_controller.dart';

class CompleteBioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteBioController>(
      () => CompleteBioController(),
    );
  }
}
