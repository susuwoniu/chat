import 'package:get/get.dart';
import 'package:chat/types/types.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';

class HomeController extends GetxController {
  final currentIndex = RxInt(0);
  final postIndexes = RxList<String>([]);
  final isLoading = true.obs;
  final currentEndCursor = ''.obs;
  final isDataEmpty = false.obs;

  final postMap = RxMap<String, PostEntity>({});

  @override
  void onReady() async {
    try {
      // await getPosts();
    } catch (e) {
      UIUtils.showError(e);
    }
    super.onReady();
  }

  getPosts({String? after}) async {
    Map<String, dynamic> query = {};
    if (after != null) {
      query["after"] = after;
    }
    final body = await APIProvider().get("/post/posts", query: query);
    if (body["data"].length == 0) {
      isDataEmpty.value = true;
    }
    for (var i = 0; i < body["data"].length; i++) {
      final item = body["data"][i];
      postMap[item["id"]] = PostEntity(
          id: item["id"],
          content: item["attributes"]["content"],
          backgroundColor: item["attributes"]["background_color"]);
      postIndexes.add(item["id"]);
    }
    if (body["meta"]["page_info"]["end"] != null) {
      currentEndCursor.value = body["meta"]["page_info"]["end"];
    }
    isLoading.value = false;
  }

  insertEntity() async {}

  @override
  void onClose() {}
  void loadingNext() async {
    try {
      getPosts(after: currentEndCursor.value);
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  void setIndex(int index) {
    currentIndex.value = index;

    // changet backgroundColor

    final backgroundColor = currentIndex.value == -1
        ? "#FFFFFF"
        : postMap[postIndexes[currentIndex.value]]!.backgroundColor;
    print("backgroundColor $backgroundColor");
    BottomNavigationBarController.to.changeBackgroundColor(backgroundColor);

    if (postIndexes.length - index < 3) {
      if (!isLoading.value && isDataEmpty.value == false) {
        isLoading.value = true;
        loadingNext();
      }
    }
  }
}
