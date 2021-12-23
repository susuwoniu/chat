import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import '../../home/controllers/home_controller.dart';

class PostSquareController extends GetxController {
  //TODO: Implement PostSquareController
  final _title = Get.arguments['title'];
  final _id = int.parse(Get.arguments['id']).toString();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  onReady() async {
    super.onReady();
    try {
      await getTemplatesSquareData();
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  getTemplatesSquareData() async {
    final result = await HomeController.to
        .getRawPosts(url: "/post/posts", postTemplateId: _id);
  }
}
