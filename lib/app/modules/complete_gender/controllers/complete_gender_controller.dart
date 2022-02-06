import 'package:get/get.dart';

class CompleteGenderController extends GetxController {
  final count = 0.obs;

  final selectedGender = ''.obs;

  void increment() => count.value++;
  void setGender(String gender) {
    selectedGender.value = gender;
  }
}
