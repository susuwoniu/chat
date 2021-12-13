import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chat/app/ui_utils/permission_util.dart';

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
  void onReady() async {
    super.onReady();
    try {
      Map<Permission, PermissionStatus> statuses =
          await PermissionUtil.request([
        Permission.camera,
        Permission.storage,
        Permission.microphone,
        Permission.speech,
        Permission.location,
      ]);
      // TODO reminder user
      print("permission statuses: $statuses");

      await AuthProvider.to.init();
      await APIProvider().init();
      _isLoading.value = false;

      _isInit.value = true;

      Get.offNamed(Routes.MAIN);

      //  router
    } catch (e) {
      _error.value = e.toString();
      _isLoading.value = false;
    }
  }

  void clearAll() {
    KVProvider.to.clear();
  }
}
