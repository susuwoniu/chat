import 'package:chat/app/providers/api_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

class MeController extends GetxController {
  static MeController get to => Get.find();

  final count = 0.obs;
  final _current = 0.obs;
  int get current => _current.value;
  final _homeController = HomeController.to;
  final totalViewedCount = 0.obs;
  final unreadViewedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    if (_homeController.isMeInitial.value == false) {
      try {
        await _homeController.getMePosts();
        await getViewedCount();
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

  getViewedCount() async {
    final result =
        await APIProvider.to.get("/notification/me/notification-inbox");
    unreadViewedCount.value = result['meta']['profile_viewed']['unread_count'];
    totalViewedCount.value = result['meta']['profile_viewed']['total_count'];
    print(result);
  }
}
