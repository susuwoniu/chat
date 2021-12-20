import 'package:get/get.dart';

import '../controllers/profile_viewers_controller.dart';

class ProfileViewersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileViewersController>(
      ProfileViewersController(),
    );
  }
}
