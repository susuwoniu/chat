import 'package:chat/app/providers/providers.dart';
import 'package:get/get.dart';

class ChangeGenderController extends GetxController {
  //TODO: Implement ChangeGenderController

  final selectedGender = "".obs;

  final count = 0.obs;
  @override
  void onInit() {
    RouterProvider.to.handleNextPageArguments(Get.arguments);
    final currentValue = Get.arguments["current-value"] as String?;
    if (currentValue != null) {
      selectedGender.value = currentValue;
    }
    super.onInit();
  }

  @override
  void onClose() {
    RouterProvider.to.handleNextPageDipose();

    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void increment() => count.value++;

  void setGender(String gender) {
    selectedGender.value = gender;
  }
}
