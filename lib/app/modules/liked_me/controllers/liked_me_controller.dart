import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/common.dart';
import 'package:chat/app/providers/providers.dart';

class LikedMeController extends GetxController {
  static LikedMeController get to => Get.find();
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  final isLoading = false.obs;

  final _isInitial = false.obs;
  bool get isInitial => _isInitial.value;

  final _isReachListEnd = false.obs;
  bool get isReachListEnd => _isReachListEnd.value;

  String? lastCursor;

  final count = 0.obs;
  final likedIdList = RxList<String>([]);
  final likedMap = RxMap<String, SimpleAccountEntity>({});

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
    } catch (e) {
      UIUtils.showError(e);
    }
    isLoading.value = false;
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  Future<List<String>> getLikedList({String? before, String? after}) async {
    Map<String, dynamic> query = {};
    if (after != null) {
      query["after"] = after;
    }
    if (before != null) {
      query["before"] = before;
    }
    final result = await APIProvider.to.get("/account/me/liked", query: query);
    List<String> indexes = [];

    if (result["included"] != null && result["data"] != null) {
      for (var v in result['included']) {
        if (v['type'] == "accounts") {
          indexes.add(v['id']);
          likedMap[v['id']] = SimpleAccountEntity.fromJson(v['attributes']);
        }
      }
      likedIdList.addAll(indexes);
      return indexes;
    }
    lastCursor = result['meta']['page_info']['end'];

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
        final result = await getLikedList(after: lastPostId);
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
}
