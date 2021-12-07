import 'package:get/get.dart';

class GenderSelectController extends GetxController {
  //TODO: Implement GenderSelectController

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
  void increment() => count.value++;

  void setGender(String gender) {
    selectedGender.value = gender;
  }
}
