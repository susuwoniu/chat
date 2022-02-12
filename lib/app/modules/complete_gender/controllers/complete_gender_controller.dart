import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class CompleteGenderController extends GetxController {
  final count = 0.obs;

  final selectedGender = ''.obs;

  void increment() => count.value++;

  var isLastAction = false;
  String actionText = "Next".tr;
  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments['is-last-action'] == "true") {
      isLastAction = true;
      actionText = "Finish".tr;
    }
    RouterProvider.to.setClosePageCountBeforeNextPage(
        RouterProvider.to.closePageCountBeforeNextPage + 1);

    super.onInit();
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }
}
