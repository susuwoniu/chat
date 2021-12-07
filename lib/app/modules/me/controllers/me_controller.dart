import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

class MeController extends GetxController {
  final count = 0.obs;
  final _current = 0.obs;
  int get current => _current.value;
  final _homeController = HomeController.to;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    if (_homeController.isMeInitial.value == false) {
      _homeController.getMePosts();
    }
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
