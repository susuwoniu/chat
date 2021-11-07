import 'package:get/get.dart';
import 'package:chat/common.dart';

class DebugController extends GetxController {
  //TODO: Implement DebugController

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
}
