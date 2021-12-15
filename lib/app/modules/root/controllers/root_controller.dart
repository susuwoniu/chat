import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';

class RootController extends GetxController {
  final _isInit = false.obs;
  bool get isInit => _isInit.value;
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  final _error = RxnString();
  String? get error => _error.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
    try {
      await AuthProvider.to.init();
      await APIProvider.to.init();
      _isLoading.value = false;

      _isInit.value = true;
      try {
        if (RouterProvider.to.nextPage != null) {
          RouterProvider.to.setClosePageCountBeforeNextPage(1);
          RouterProvider.to.toNextPage();
        } else {
          Get.offNamed(Routes.MAIN);
        }
      } catch (e) {
        Log.error(e);
        Get.offNamed(Routes.MAIN);
      }

      //  router
    } catch (e) {
      _error.value = e.toString();
      _isLoading.value = false;
    }
  }

  void clearAll() {
    CacheProvider.to.clear();
    AccountStoreProvider.to.clear();
    KVProvider.to.clear();
  }
}
