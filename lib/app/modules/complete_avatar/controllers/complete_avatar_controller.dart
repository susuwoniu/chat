import 'package:chat/types/account.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class CompleteAvatarController extends GetxController {
  static CompleteAvatarController get to => Get.find();

  final Rxn<ImageEntity> avatar = Rxn();
  String actionText = "Next".tr;
  var isLastAction = false;
  final count = 0.obs;
  @override
  void onInit() {
    RouterProvider.to.setClosePageCountBeforeNextPage(
        RouterProvider.to.closePageCountBeforeNextPage + 1);
    if (Get.arguments != null && Get.arguments['is-last-action'] == "true") {
      isLastAction = true;
      actionText = "Finish".tr;
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void increment() => count.value++;
}
