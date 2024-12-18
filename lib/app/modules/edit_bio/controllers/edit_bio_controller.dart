import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class EditBioController extends GetxController {
  static EditBioController get to => Get.find();

  final isActived = false.obs;
  final String initialContent = AuthProvider.to.account.value.bio ?? "";
  final currentBio = (AuthProvider.to.account.value.bio ?? "").obs;
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

  @override
  void onReady() {
    super.onReady();
  }

  void increment() => count.value++;
}
