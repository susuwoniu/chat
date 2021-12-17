import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/common.dart';
import 'package:chat/types/types.dart';

class OtherController extends GetxController {
  //TODO: Implement OtherController
  static OtherController get to => Get.find();

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
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    try {
      await getAccountsPosts(id: accountId);
      // await APIProvider.to.get('/account/accounts/$accountId/profile-images');
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  @override
  void onClose() {}
  void increment() => count.value++;
  void setCurrent(i) {
    _current.value = i;
  }

  getAccountsPosts({String? after, required String id}) async {
    final result = await _homeController.getRawPosts(
        after: after, url: "/post/accounts/$id/posts");
    postMap.addAll(result.postMap);
    myPostsIndexes.addAll(result.indexes);

    isLoadingPosts.value = false;
    if (isInitial.value == false) {
      isInitial.value = true;
    }
  }
}
