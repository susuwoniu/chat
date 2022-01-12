import 'package:chat/app/providers/api_provider.dart';
import 'package:chat/app/providers/auth_provider.dart';
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
  var isCreate = true.obs;
  var nextCreateTime = ''.obs;

  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId);
    });
    super.onInit();
  }

  @override
  void onReady() async {
    if (AuthProvider.to.account.value.next_post_not_before != null) {
      setIsCreate(
          DateTime.parse(AuthProvider.to.account.value.next_post_not_before!));
    }
    super.onReady();
  }

  Future<void> fetchPage(String? lastPostId) async {
    List<String> indexes = [];

    try {
      indexes = await HomeController.to.getMePosts(after: lastPostId);
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

  setIsCreate(DateTime time) {
    final now = DateTime.now();
    isCreate.value = now.isAfter(time);
    final DateFormat formatter = DateFormat('H:mm');
    nextCreateTime.value = formatter.format(time);
  }
}
