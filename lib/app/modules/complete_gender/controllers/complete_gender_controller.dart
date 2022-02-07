import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class CompleteGenderController extends GetxController {
  final count = 0.obs;

  final selectedGender = ''.obs;

  void increment() => count.value++;

  final isLastAction = Get.arguments['is-last-action'];
  String actionText = "Next".tr;
  @override
  void onInit() {
    if (isLastAction != null && isLastAction) {
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
