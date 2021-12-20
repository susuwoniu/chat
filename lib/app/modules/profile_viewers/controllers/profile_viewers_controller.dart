import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:get/get.dart';
import '../../me/controllers/me_controller.dart';
import 'package:chat/types/types.dart';

class ProfileViewersController extends GetxController {
  //TODO: Implement ProfileViewersController
  static ProfileViewersController get to => Get.find();

  final count = 0.obs;
  var profileViewerList = RxList<SimpleAccountEntity>([]);

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

  getProfileViewersList() async {
    final result = await APIProvider.to.get("/account/me/views");
    final _list = result['data'];

    profileViewerList = result;
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
