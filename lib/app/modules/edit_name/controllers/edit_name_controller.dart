import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class EditNameController extends GetxController {
  static EditNameController get to => Get.find();

  final isActived = false.obs;
  final String initialContent = AuthProvider.to.account.value.name;
  final currentTitle = Get.arguments["action"];
  final currentName = AuthProvider.to.account.value.name.obs;
  final count = 0.obs;
  @override
  void onInit() {
    RouterProvider.to.handleNextPageArguments(Get.arguments);

    super.onInit();
  }

  @override
  void onClose() {
    RouterProvider.to.handleNextPageDipose();

    super.onClose();
  }

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

  @override
  void onReady() {
    super.onReady();
  }

  void increment() => count.value++;

  void setIsActived(bool value) {
    isActived.value = value;
  }
}
