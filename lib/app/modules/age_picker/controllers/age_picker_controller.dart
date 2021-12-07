import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';

class AgePickerController extends GetxController {
  //TODO: Implement AgePickerController
  final _loginController = LoginController.to;

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
    final account = await _loginController.postAccountInfoChange({
      "birthday": birthYear.value + "-01-01",
    });
  }
}
