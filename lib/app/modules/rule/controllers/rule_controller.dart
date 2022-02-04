import 'package:get/get.dart';

class RuleController extends GetxController {
  //TODO: Implement RuleController

  final count = 0.obs;
  final String content = Get.arguments['content'] ?? '';
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
}
