import 'package:chat/app/providers/api_provider.dart';
import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/providers/account_provider.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/common.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

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
  int nextCreateTime = 0;
  String? _nextPageKey;
  bool _isLastPage = false;

  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId);
    });
    ever(HomeController.to.myPostsIndexes, (_) {
      pagingController.value = PagingState(
        nextPageKey: _nextPageKey,
        itemList: HomeController.to.myPostsIndexes,
      );
    });
    super.onInit();
  }

  @override
  void onReady() async {
    await AccountProvider.to.getMe();

    getTimeStop();
    super.onReady();
  }

  Future<void> fetchPage(String? lastPostId) async {
    List<String> indexes = [];
    if (_isLastPage) {
      pagingController.value = PagingState(
        nextPageKey: null,
        itemList: HomeController.to.myPostsIndexes,
      );
      return;
    }
    try {
      indexes = await HomeController.to.getMePosts(after: lastPostId);
    } catch (e) {
      UIUtils.showError(e);
    }

    final isLastPage = indexes.length < DEFAULT_PAGE_SIZE;
    _isLastPage = isLastPage;
    _nextPageKey = indexes.last;

    if (isLastPage) {
      pagingController.value = PagingState(
        nextPageKey: null,
        itemList: HomeController.to.myPostsIndexes,
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  void setCurrent(i) {
    _current.value = i;
  }

  getViewedCount() async {
    final result =
        await APIProvider.to.get("/notification/me/notification-inbox");
    unreadViewedCount.value = result['meta']['profile_viewed']['unread_count'];
    totalViewedCount.value = result['meta']['profile_viewed']['total_count'];
    print(result);
  }

  getTimeStop() {
    final now = DateTime.parse(AccountProvider.to.serverTime);
    // final now = DateTime.now();
    // final next = DateTime.parse('2022-01-16 06:29:00.692634');

    final next = AuthProvider.to.account.value.next_post_not_before != null
        ? DateTime.parse(AuthProvider.to.account.value.next_post_not_before!)
        : null;
    if (next != null) {
      nextCreateTime = next.difference(now).inSeconds;
    }
  }
}
