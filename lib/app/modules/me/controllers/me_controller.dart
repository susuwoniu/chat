import 'package:chat/app/providers/providers.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/common.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:async';

class MeController extends GetxController {
  static MeController get to => Get.find();
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);
  final count = 0.obs;
  final _current = 0.obs;
  int get current => _current.value;
  final totalViewedCount = 0.obs;
  final unreadViewedCount = 0.obs;
  final isLoadingImages = true.obs;
  String? _nextPageKey;
  final isLast = false.obs;
  final myPostsIndexes = RxList<String>(['create']);
  final isMeInitial = false.obs;
  final isLoadingMyPosts = false.obs;

  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId);
    });
    ever(myPostsIndexes, (_) {
      pagingController.value = PagingState(
        nextPageKey: _nextPageKey,
        itemList: myPostsIndexes,
      );
    });
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> refreshData() async {
    pagingController.refresh();
    await Future.wait<void>([
      AccountProvider.to.getMe(),
    ]);
    return;
  }

  // clearUnreadViewerCount() async {
  //   await APIProvider.to.patch("/notification/me/notification-inbox",
  //       body: {"type": "profile_viewed", "unread_count_action": "clear"});
  //   MeController.to.unreadViewedCount.value = 0;
  // }

  Future<void> fetchPage(String? lastPostId) async {
    if (isLast.value) {
      pagingController.value = PagingState(
        nextPageKey: null,
        itemList: myPostsIndexes,
      );
      return;
    }
    try {
      await getMePosts(after: lastPostId);
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  Future<List<String>> getMePosts({String? after}) async {
    isLoadingMyPosts.value = true;
    final result = await getApiPosts(after: after, url: "/post/me/posts");
    count.value++;
    final isLastPage = result.indexes.isEmpty;
    if (result.indexes.isNotEmpty) {
      _nextPageKey = result.endCursor;
    }
    isLast.value = isLastPage;
    HomeController.to.postMap.addAll(result.postMap);
    myPostsIndexes.addAll(result.indexes);
    await AuthProvider.to.saveSimpleAccounts(result.accountMap);

    isLoadingMyPosts.value = false;
    if (isMeInitial.value == false) {
      isMeInitial.value = true;
    }
    return result.indexes;
  }

  @override
  void onClose() {
    _current.value = 0;
    super.onClose();
  }

  void increment() => count.value++;
  void setCurrent(i) {
    _current.value = i;
  }

  // getViewedCount() async {
  //   final result =
  //       await APIProvider.to.get("/notification/me/notification-inbox");
  //   unreadViewedCount.value = result['meta']['profile_viewed']['unread_count'];
  //   totalViewedCount.value = result['meta']['profile_viewed']['total_count'];
  //   print(result);
  // }
}
