import 'package:get/get.dart';
import 'package:chat/app/providers/auth_provider.dart';

class EditNameController extends GetxController {
  static EditNameController get to => Get.find();

  final isActived = false.obs;
  final String initialContent = AuthProvider.to.account.value.name;
  final currentTitle = Get.arguments["action"];
  final currentName = AuthProvider.to.account.value.name.obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
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

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void setIsActived(bool value) {
    isActived.value = value;
  }
}
