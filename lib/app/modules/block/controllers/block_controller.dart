import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BlockController extends GetxController {
  //TODO: Implement FeedbackController
  static BlockController get to => Get.find();

  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
