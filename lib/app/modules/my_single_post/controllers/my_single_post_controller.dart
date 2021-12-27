import 'package:chat/app/providers/api_provider.dart';
import 'package:get/get.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import '../../home/controllers/home_controller.dart';

class MySinglePostController extends GetxController {
  //TODO: Implement MySinglePostController

  final _homeController = HomeController.to;
  final _postId = Get.arguments['postId'];
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    try {
      final post = _homeController.postMap[_postId];
      if (post != null && post.views == null) {
        await _homeController.getRawVisitorList(_postId);
      }
    } catch (e) {
      UIUtils.showError(e);
    }
    super.onReady();
  }

  void increment() => count.value++;
  onDeletePost(id) async {
    await APIProvider.to.delete('/post/posts/$id');
  }
}
