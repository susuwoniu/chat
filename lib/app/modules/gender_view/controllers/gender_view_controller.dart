import 'package:get/get.dart';

class GenderViewController extends GetxController {
  //TODO: Implement GenderViewController

  final selectedGender = ''.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  setGender(String gender) {
    selectedGender.value = gender;
  }
}
