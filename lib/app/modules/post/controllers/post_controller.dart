import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';
import 'package:tcard/tcard.dart';

class PostController extends GetxController {
  static PostController get to => Get.find();

  final TCardController tcardController = TCardController();
  final count = 0.obs;
  final index = 0.obs;
  final initError = RxnString();
  final isReachEnd = false.obs;
  String? firstCursor;
  String? lastCursor;
  final postTemplatesIndexes = RxList<String>([]);
  final postTemplatesMap = RxMap<String, PostTemplatesEntity>({});
  final isLoading = true.obs;
  final isDataEmpty = false.obs;
  final isInit = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    isLoading.value = true;
    try {
      await getPosts();
      isInit.value = true;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      initError.value = e.toString();
      isInit.value = true;

      UIUtils.showError(e);
    }
  }

  void increment() => count.value++;
  void setIndex(int i) {
    if (i >= postTemplatesIndexes.length) {
      index.value = 0;
      if (!isLoading.value &&
          isDataEmpty.value == false &&
          lastCursor != null) {
        isLoading.value = true;
        getPosts(after: lastCursor).then((_) {
          isLoading.value = false;
        }).catchError((e) {
          isLoading.value = false;
        });
      } else if (isLoading.value == false &&
          isReachEnd.value == true &&
          firstCursor != null) {
        // 拉取最新的
        isLoading.value = true;
        getPosts(before: firstCursor).then((_) {
          isLoading.value = false;
        }).catchError((e) {
          isLoading.value = false;
        });
      }
    } else {
      index.value = i;
    }
  }

  Future<void> getPosts({String? after, String? before}) async {
    // todo
    Map<String, dynamic> query = {
      // "featured": "true",
      "limit": DEFAULT_PAGE_SIZE.toString(),
    };
    if (after != null) {
      query["after"] = after;
    }
    if (before != null) {
      query["before"] = before;
    }
    isDataEmpty.value = false; // init set empty null
    postTemplatesIndexes.clear();
    // todo featured
    isReachEnd.value = false;
    final body = await APIProvider.to.get("/post/post-templates", query: query);
    if (body["data"].length == 0) {
      if (isInit.value == false) {
        isDataEmpty.value = true;
      }
      isReachEnd.value = true;
      return;
    }
    String? newEndCursor;
    String? newStartCursor;
    if (body["meta"]["page_info"]["end"] != null) {
      newEndCursor = body["meta"]["page_info"]["end"];
    }
    if (body["meta"]["page_info"]["start"] != null) {
      newStartCursor = body["meta"]["page_info"]["start"];
    }
    if (after == null && before == null) {
      firstCursor = newStartCursor!;
      lastCursor = newEndCursor!;
    } else if (after != null && before == null) {
      lastCursor = newEndCursor!;
    } else if (before != null && after == null) {
      firstCursor = newStartCursor!;
    }
    final Map<String, PostTemplatesEntity> newMap = {};
    final List<String> newIndexes = [];
    for (var i = 0; i < body["data"].length; i++) {
      final item = body["data"][i];
      final id = item["id"];
      final attributes = item["attributes"];
      newMap[id] = PostTemplatesEntity.fromJson(attributes);
      newIndexes.add(id);
    }
    if (newIndexes.isNotEmpty) {
      postTemplatesMap.addAll(newMap);
      postTemplatesIndexes.addAll(newIndexes);
    }
  }
}
