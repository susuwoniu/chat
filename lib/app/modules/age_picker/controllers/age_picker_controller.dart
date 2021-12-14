import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class AgePickerController extends GetxController {
  final count = 0.obs;
  final birthYear = '1998'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void increment() => count.value++;

  void setBirthYear(String year) {
    birthYear.value = year;
  }

  Future<void> updateAge() async {
    final account = await AccountProvider.to.postAccountInfoChange({
      "birthday": birthYear.value + "-01-01",
    });
  }
}
