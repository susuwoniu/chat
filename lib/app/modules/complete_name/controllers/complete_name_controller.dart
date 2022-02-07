import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class CompleteNameController extends GetxController {
  static CompleteNameController get to => Get.find();

  final isActived = false.obs;
  final String initialContent = "";
  final currentName = "".obs;
  final count = 0.obs;
  onChangeTextValue(String value) {
    final text = value.trim();
    currentName.value = text;
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

  void setIsActived(bool value) {
    isActived.value = value;
  }
}
