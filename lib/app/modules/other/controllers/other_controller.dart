import 'package:chat/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:chat/common.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/app/providers/providers.dart';

class OtherController extends GetxController {
  //TODO: Implement OtherController
  static OtherController get to => Get.find();
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);
  final count = 0.obs;
  final _current = 0.obs;
  int get current => _current.value;
  final isInitial = false.obs;
  final isLoadingPosts = false.obs;
  final myPostsIndexes = RxList<String>([]);
  final postMap = RxMap<String, PostEntity>({});
  final accountId = Get.arguments['accountId'];

  // final ScrollController listScrollController = ScrollController();

  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId);
    });
    super.onInit();
  }

  @override
  void onReady() async {
    // listScrollController.addListener(() {
    //   final position = listScrollController.offset;
    //   if (position > 350) {
    //     isShowAppBar.value = true;
    //     return;
    //   } else {
    //     isShowAppBar.value = false;
    //     return;
    //   }
    // });
    super.onReady();
    try {
      await HomeController.to.getOtherAccount(id: accountId, force: true);
      await APIProvider.to.patch('/account/accounts/$accountId',
          body: {'viewed_count_action': 'increase_one'});
    } catch (e) {
      UIUtils.showError(e);
    }
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
  void onClose() {
    // listScrollController.removeListener(() {});
  }

  void increment() => count.value++;
  void setCurrent(i) {
    _current.value = i;
  }

  Future<List<String>> getAccountsPosts(
      {String? after, required String id}) async {
    isLoadingPosts.value = true;
    final result =
        await getApiPosts(after: after, url: "/post/accounts/$id/posts");
    postMap.addAll(result.postMap);
    myPostsIndexes.addAll(result.indexes);

    isLoadingPosts.value = false;
    if (isInitial.value == false) {
      isInitial.value = true;
    }
    return result.indexes;
  }

  postLikeCount(String id) async {
    await APIProvider.to.patch("/account/accounts/$id",
        body: {"like_count_action": 'increase_one'});
  }

  cancelLikeCount(String id) async {
    await APIProvider.to.patch("/account/accounts/$id",
        body: {"like_count_action": 'decrease_one'});
  }

  accountAction({bool isLiked = true, required bool increase}) {
    final _account = AuthProvider.to.simpleAccountMap[accountId] ??
        SimpleAccountEntity.empty();
    if (isLiked) {
      _account.is_liked = increase;
    } else {
      _account.is_blocked = increase;
    }
    AuthProvider.to.simpleAccountMap[accountId] = _account;
  }

  toggleBlock({required String id, required bool toBlocked}) async {
    await APIProvider.to.patch("/account/accounts/$id", body: {
      "block_count_action": toBlocked ? 'increase_one' : 'decrease_one'
    });
  }
}
