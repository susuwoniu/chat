import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/common.dart';
import 'package:chat/types/types.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OtherController extends GetxController {
  //TODO: Implement OtherController
  static OtherController get to => Get.find();
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);
  final count = 0.obs;
  final _current = 0.obs;
  int get current => _current.value;
  final _homeController = HomeController.to;
  final isInitial = false.obs;
  final isLoadingPosts = false.obs;

  final myPostsIndexes = RxList<String>([]);
  final postMap = RxMap<String, PostEntity>({});
  final accountId = Get.arguments['accountId'];

  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId);
    });
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> fetchPage(String? lastPostId) async {
    List<String> indexes = [];

    try {
      indexes = await getAccountsPosts(id: accountId, after: lastPostId);
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
  void setCurrent(i) {
    _current.value = i;
  }

  Future<List<String>> getAccountsPosts(
      {String? after, required String id}) async {
    isLoadingPosts.value = true;
    final result = await _homeController.getRawPosts(
        after: after, url: "/post/accounts/$id/posts");
    postMap.addAll(result.postMap);
    myPostsIndexes.addAll(result.indexes);

    isLoadingPosts.value = false;
    if (isInitial.value == false) {
      isInitial.value = true;
    }
    return result.indexes;
  }
}
