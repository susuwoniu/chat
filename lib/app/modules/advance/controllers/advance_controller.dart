import 'package:get/get.dart';

class AdvanceController extends GetxController {
  //TODO: Implement AdvanceController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> clearAllServerNotifications() async {}

  void increment() => count.value++;
}
