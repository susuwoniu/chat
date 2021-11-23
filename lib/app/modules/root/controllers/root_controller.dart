import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chat/app/ui_utils/permission_util.dart';

class RootController extends GetxController {
  final _isInit = false.obs;
  bool get isInit => _isInit.value;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    Map<Permission, PermissionStatus> statuses = await PermissionUtil.request([
      Permission.camera,
      Permission.storage,
      Permission.microphone,
      Permission.speech,
      Permission.location,
    ]);
    // await ImProvider.to.init();

    await AuthProvider.to.init();
    await APIProvider().init();

    _isInit.value = true;
    // todo router
    Get.offNamed(Routes.MAIN);
    super.onReady();
  }
}
