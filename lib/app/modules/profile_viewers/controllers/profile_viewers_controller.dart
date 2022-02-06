import 'package:chat/app/providers/providers.dart';
import 'package:get/get.dart';
import '../../me/controllers/me_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/common.dart';

class ViewerEntity {
  final SimpleAccountEntity account;
  final DateTime updatedAt;
  final int viewedCount;

  ViewerEntity({
    required this.account,
    required this.updatedAt,
    required this.viewedCount,
  });
}

class ProfileViewersController extends GetxController {
  static ProfileViewersController get to => Get.find();
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  final isLoading = false.obs;

  final _isInitial = false.obs;
  bool get isInitial => _isInitial.value;

  final _isReachListEnd = false.obs;
  bool get isReachListEnd => _isReachListEnd.value;

  String? lastCursor;

  final count = 0.obs;
  final profileViewerIdList = RxList<String>([]);
  final Map<String, ViewerEntity> profileViewerMap = {};

  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId: lastPostId);
    });
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    try {
      isLoading.value = true;
      await clearUnreadViewerCount();
    } catch (e) {
      UIUtils.showError(e);
    }
    isLoading.value = false;
  }

  void increment() => count.value++;
  clearUnreadViewerCount() async {
    await APIProvider.to.patch("/notification/me/notification-inbox",
        body: {"type": "profile_viewed", "unread_count_action": "clear"});
    MeController.to.unreadViewedCount.value = 0;
  }

  Future<List<String>> getProfileViewersList(
      {String? before, String? after}) async {
    Map<String, dynamic> query = {};
    if (after != null) {
      query["after"] = after;
    }
    if (before != null) {
      query["before"] = before;
    }
    final result = await APIProvider.to.get("/account/me/views", query: query);
    final Map<String, SimpleAccountEntity> accountMap = {};

    if (result["included"] != null) {
      for (var v in result['included']) {
        if (v['type'] == "accounts") {
          accountMap[v['id']] = SimpleAccountEntity.fromJson(v['attributes']);
        }
      }
    }
    lastCursor = result['meta']['page_info']['end'];

    List<String> indexes = [];
    if (result['data'] != null) {
      for (var v in result['data']) {
        final viewerId = v['attributes']['viewed_by'];
        profileViewerMap[viewerId] = ViewerEntity(
          account: accountMap[viewerId]!,
          updatedAt: DateTime.parse(v['attributes']['updated_at']),
          viewedCount: v['attributes']['viewed_count'],
        );
        indexes.add(viewerId);
      }

      profileViewerIdList.addAll(indexes);
      return indexes;
    }
    return [];
  }

  Future<List<String>> fetchPage({
    bool replace = false,
    String? lastPostId,
  }) async {
    if (isLoading.value == false) {
      isLoading.value = true;

      List<String> indexes = [];
      try {
        final result = await getProfileViewersList(after: lastPostId);
        if (_isInitial.value == false) {
          _isInitial.value = true;
        }
        indexes = result;
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
        UIUtils.showError(e);
        return indexes;
      }

      final isLastPage = indexes.isEmpty;
      if (isLastPage) {
        _isReachListEnd.value = true;
        pagingController.appendLastPage(indexes);
      } else {
        pagingController.appendPage(indexes, lastCursor);
      }

      return indexes;
    } else {
      return [];
    }
  }
//   setDateName(DateTime date) {
//     if (calculateDifference(date) == -1) {
//       return 'Yesterday';
//     } else if (calculateDifference(date) == 0) {
//       return 'Today';
//     } else {
//       if (date.year == DateTime.now().year) {
//         return DateTime(date.month, date.day);
//       } else {
//         return DateTime(date.year, date.month, date.day);
//       }
//     }
//   }

//   int calculateDifference(DateTime date) {
//     DateTime now = DateTime.now();
//     return DateTime(date.year, date.month, date.day)
//         .difference(DateTime(now.year, now.month, now.day))
//         .inDays;
//   }

}
