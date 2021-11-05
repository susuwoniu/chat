import 'package:get/get.dart';

class UIUtils {
  static snackbar(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: Get.context?.theme.primaryColor);
  }
}
