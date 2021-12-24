import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/common.dart';
import 'package:chat/types/types.dart';

class PostSquareController extends GetxController {
  static HomeController get to => Get.find();

  //TODO: Implement PostSquareController

  final _id = int.parse(Get.arguments['id']).toString();
  final usedCount = 0.obs;
  final _homeController = HomeController.to;
  final isInitial = false.obs;
  final isLoadingPosts = false.obs;
  final myPostsIndexes = RxList<String>([]);
  final postMap = RxMap<String, PostEntity>({});

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  onReady() async {
    super.onReady();
    try {
      await getTemplatesSquareData(postTemplateId: _id);
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  getTemplatesSquareData(
      {String? after, required String postTemplateId}) async {
    final result = await _homeController.getRawPosts(
        after: after, url: "/post/posts", postTemplateId: _id);
    postMap.addAll(result.postMap);
    myPostsIndexes.addAll(result.indexes);
    isLoadingPosts.value = false;
    if (isInitial.value == false) {
      isInitial.value = true;
    }
  }

  getUsedCount() async {
    final result = await APIProvider.to.get('/post/post-templates/$_id');
    usedCount.value = result['used_count'];
  }
}
