import 'package:get/get.dart';
import 'package:chat/app/providers/auth_provider.dart';

class EditBioController extends GetxController {
  static EditBioController get to => Get.find();

  final isActived = false.obs;
  final String initialContent = AuthProvider.to.account.value.bio ?? "";
  final currentTitle = Get.arguments["action"];
  final currentBio = (AuthProvider.to.account.value.bio ?? "").obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

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
