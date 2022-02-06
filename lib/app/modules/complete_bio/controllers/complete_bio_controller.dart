import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class CompleteBioController extends GetxController {
  static CompleteBioController get to => Get.find();

  final isActived = false.obs;
  final String initialContent = AuthProvider.to.account.value.bio ?? "";
  final currentBio = (AuthProvider.to.account.value.bio ?? "").obs;
  final count = 0.obs;
  final isLastAction = Get.arguments['is-last-action'];
  String actionText = "Next".tr;
  @override
  void onInit() {
    if (isLastAction != null && isLastAction) {
      actionText = "Finish".tr;
    }

    RouterProvider.to.setClosePageCountBeforeNextPage(
        RouterProvider.to.closePageCountBeforeNextPage + 1);

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void increment() => count.value++;
  onChangeTextValue(String value) {
    final text = value.trim();
    currentBio.value = text;
    if (text.isEmpty) {
      setIsActived(false);
    }

    if (text.isNotEmpty) {
      if (text != initialContent) {
        setIsActived(true);
      } else {
        setIsActived(false);
      }
    }
  }

  void setIsActived(bool value) {
    isActived.value = value;
  }
}
