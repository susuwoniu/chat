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
    isDataEmpty.value = false; // init set empty null
    postTemplatesIndexes.clear();
    // todo featured
    isReachEnd.value = false;
    final result = await getRawPostTemplates(after: after, before: before);
    if (result.postTemplatesIndexes.isEmpty) {
      if (isInit.value == false) {
        isDataEmpty.value = true;
      }
      isReachEnd.value = true;
      return;
    }

    if (after == null && before == null) {
      firstCursor = result.startCursor!;
      lastCursor = result.endCursor!;
    } else if (after != null && before == null) {
      lastCursor = result.endCursor!;
    } else if (before != null && after == null) {
      firstCursor = result.startCursor!;
    }

    if (result.postTemplatesIndexes.isNotEmpty) {
      postTemplatesMap.addAll(postTemplatesMap);
      postTemplatesIndexes.addAll(postTemplatesIndexes);
    }
  }
}
