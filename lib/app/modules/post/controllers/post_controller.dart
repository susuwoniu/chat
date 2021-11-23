import 'package:get/get.dart';
import 'package:chat/types/types.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';

class PostController extends GetxController {
  static PostController get to => Get.find();

  final count = 0.obs;
  final index = 0.obs;
  final postTemplatesIndexes = RxList<String>([]);
  final postTemplatesMap = RxMap<String, PostTemplatesEntity>({
    // "1": PostTemplatesEntity(
    //     backgroundColor: "#22222", id: "1", content: "11111111"
    // )
  });
  final isLoading = true.obs;
  final currentEndCursor = ''.obs;
  final isDataEmpty = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    try {
      await getPosts();
    } catch (e) {
      UIUtils.showError(e);
    }
    super.onReady();
  }

  void increment() => count.value++;
  void setIndex(int i) {
    index.value = i;
    if (postTemplatesIndexes.length - index.value < 3) {
      if (!isLoading.value && isDataEmpty.value == false) {
        isLoading.value = true;
      }
    }
  }

  getPosts({String? after}) async {
    Map<String, dynamic> query = {};
    if (after != null) {
      query["after"] = after;
    }
    final body = await APIProvider().get("/post/post-templates", query: query);
    if (body["data"].length == 0) {
      isDataEmpty.value = true;
    }
    for (var i = 0; i < body["data"].length; i++) {
      final item = body["data"][i];
      postTemplatesMap[item["id"]] = PostTemplatesEntity(
          id: item["id"],
          content: item["attributes"]["content"],
          backgroundColor: item["attributes"]["background_color"]);
      postTemplatesIndexes.add(item["id"]);
    }

    isLoading.value = false;
  }
}
