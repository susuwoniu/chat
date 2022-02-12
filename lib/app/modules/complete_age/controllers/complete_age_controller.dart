import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class CompleteAgeController extends GetxController {
  final count = 0.obs;
  final birthYear = '1998'.obs;

  var isLastAction = false;
  String actionText = "Next".tr;
  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments['is-last-action'] == "true") {
      isLastAction = true;
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

  void setBirthYear(String year) {
    birthYear.value = year;
  }

  Future<void> updateAge() async {
    final account = await AccountProvider.to.postAccountInfoChange({
      "birthday": birthYear.value + "-01-01",
    });
    // if next action to next action
    AuthProvider.to.checkActions(account.actions);
  }
}
