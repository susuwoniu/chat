import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

class AddProfileImageController extends GetxController {
  //TODO: Implement AddProfileImageController

  final count = 0.obs;
  @override
  void onInit() {
    RouterProvider.to.setClosePageCountBeforeNextPage(
        RouterProvider.to.closePageCountBeforeNextPage + 1);

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void increment() => count.value++;
}
