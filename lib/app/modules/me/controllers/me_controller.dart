import 'package:get/get.dart';

class MeController extends GetxController {
  final count = 0.obs;
  final _current = 0.obs;
  int get current => _current.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  void setCurrent(i) {
    _current.value = i;
  }
}
