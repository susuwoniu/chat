import 'package:chat/app/ui_utils/ui_utils.dart';
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
  void onReady() async {
    if (_homeController.isMeInitial.value == false) {
      try {
        await _homeController.getMePosts();
      } catch (e) {
        UIUtils.showError(e);
      }
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
