import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/common.dart';
import 'package:chat/types/types.dart';
import '../../post/controllers/post_controller.dart';

class PostSquareController extends GetxController {
  static PostSquareController get to => Get.find();

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
      await getTemplateData();
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  getTemplatesSquareData(
      {String? after, required String postTemplateId}) async {
    isLoadingPosts.value = true;
    final result = await _homeController.getRawPosts(
        after: after, url: "/post/posts", postTemplateId: _id);
    myPostsIndexes.clear();
    postMap.addAll(result.postMap);
    myPostsIndexes.addAll(result.indexes);
    _homeController.postMap.addAll(result.postMap);

    isLoadingPosts.value = false;
    if (isInitial.value == false) {
      isInitial.value = true;
    }
  }

  Future<List<String>> getTemplateData() async {
    final result = await APIProvider.to.get('/post/post-templates/$_id');
    usedCount.value = result['data']['attributes']['used_count'];
    if (PostController.to.postTemplatesMap[_id] == null) {
      PostController.to.postTemplatesMap[_id] =
          PostTemplatesEntity.fromJson(result['data']['attributes']);
    }
    return result.indexes;
  }
}
