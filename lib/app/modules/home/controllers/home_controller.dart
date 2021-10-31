import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  @override
  void onReady() {
    super.onReady();
    // todo
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
