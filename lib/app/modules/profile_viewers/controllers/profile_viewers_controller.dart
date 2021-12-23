import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import '../../me/controllers/me_controller.dart';
import 'package:chat/types/types.dart';

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
  //TODO: Implement ProfileViewersController
  static ProfileViewersController get to => Get.find();

  final count = 0.obs;
  final profileViewerIdList = RxList<String>([]);
  final Map<String, ViewerEntity> profileViewerMap = {};

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    try {
      await clearUnreadViewerCount();
      await getProfileViewersList();
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  @override
  void onClose() {}
  void increment() => count.value++;
  clearUnreadViewerCount() async {
    await APIProvider.to.patch("/notification/me/notification-inbox",
        body: {"type": "profile_viewed", "unread_count_action": "clear"});
    MeController.to.unreadViewedCount.value = 0;
  }

  getProfileViewersList({String? before, String? after}) async {
    Map<String, dynamic> query = {};
    if (after != null) {
      query["after"] = after;
    }
    if (before != null) {
      query["before"] = before;
    }
    final result = await APIProvider.to.get("/account/me/views");
    final Map<String, SimpleAccountEntity> accountMap = {};

    if (result["included"] != null) {
      for (var v in result['included']) {
        if (v['type'] == "accounts") {
          accountMap[v['id']] = SimpleAccountEntity.fromJson(v['attributes']);
        }
      }
    }
    if (result['data'] != null) {
      for (var v in result['data']) {
        final viewerId = v['attributes']['viewed_by'];
        profileViewerMap[viewerId] = ViewerEntity(
          account: accountMap[viewerId]!,
          updatedAt: DateTime.parse(v['attributes']['updated_at']),
          viewedCount: v['attributes']['viewed_count'],
        );
        profileViewerIdList.add(viewerId);
      }
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
