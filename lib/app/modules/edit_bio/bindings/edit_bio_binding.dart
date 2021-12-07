import 'package:get/get.dart';

import '../controllers/edit_bio_controller.dart';

class EditBioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditBioController>(
      () => EditBioController(),
    );
  }
}
