import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class RuleController extends GetxController {
  //TODO: Implement RuleController

  final count = 0.obs;
  final String content = Get.arguments['content'] ?? '';

  @override
  void onReady() {
    RouterProvider.to.setClosePageCountBeforeNextPage(
        RouterProvider.to.closePageCountBeforeNextPage + 1);
    super.onReady();
  }

  void increment() => count.value++;
}
