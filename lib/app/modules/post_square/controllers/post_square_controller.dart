import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/common.dart';
import 'package:chat/types/types.dart';
import '../../post/controllers/post_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PostSquareController extends GetxController {
  static PostSquareController get to => Get.find();

  //TODO: Implement PostSquareController
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  final _id = Get.arguments['id'];
  final usedCount = 0.obs;
  final _homeController = HomeController.to;
  final isInitial = false.obs;
  final isLoadingPosts = false.obs;
  final squarePostsIndexes = RxList<String>([]);
  final postMap = RxMap<String, PostEntity>({});

  final count = 0.obs;
  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId);
    });
    super.onInit();
  }

  @override
  onReady() async {
    super.onReady();
    try {
      await getTemplateData();
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  Future<void> fetchPage(String? lastPostId) async {
    List<String> indexes = [];

    try {
      indexes =
          await getTemplatesSquareData(postTemplateId: _id, after: lastPostId);
    } catch (e) {
      UIUtils.showError(e);
    }

    final isLastPage = indexes.length < DEFAULT_PAGE_SIZE;
    if (isLastPage) {
      pagingController.appendLastPage(indexes);
    } else {
      final nextPageKey = indexes.last;
      pagingController.appendPage(indexes, nextPageKey);
    }
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  Future<List<String>> getTemplatesSquareData(
      {String? after, required String postTemplateId}) async {
    isLoadingPosts.value = true;
    final result = await _homeController.getRawPosts(
        after: after, url: "/post/posts", postTemplateId: _id);
    squarePostsIndexes.clear();
    postMap.addAll(result.postMap);
    squarePostsIndexes.addAll(result.indexes);
    _homeController.postMap.addAll(result.postMap);

    isLoadingPosts.value = false;
    if (isInitial.value == false) {
      isInitial.value = true;
    }
    return result.indexes;
  }

  getTemplateData() async {
    final result = await APIProvider.to.get('/post/post-templates/$_id');
    usedCount.value = result['data']['attributes']['used_count'];
    if (PostController.to.postTemplatesMap[_id] == null) {
      PostController.to.postTemplatesMap[_id] =
          PostTemplatesEntity.fromJson(result['data']['attributes']);
    }
  }
}
