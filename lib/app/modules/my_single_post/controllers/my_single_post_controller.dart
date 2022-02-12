import 'package:chat/app/providers/api_provider.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/app/providers/auth_provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/common.dart';

class MySinglePostController extends GetxController {
  static MySinglePostController get to => Get.find();

  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  final _postId = Get.arguments['id'];
  final isMe = HomeController.to.postMap[Get.arguments['id']]!.accountId ==
      AuthProvider.to.accountId;

  final _visibility =
      HomeController.to.postMap[Get.arguments['id']]!.visibility.obs;
  String get visibility => _visibility.value;

  final isLoading = false.obs;

  final _isInitial = false.obs;
  bool get isInitial => _isInitial.value;

  final _isReachListEnd = false.obs;
  bool get isReachListEnd => _isReachListEnd.value;

  String? lastCursor;

  final viewerIdList = RxList<String>([]);
  final viewerIdMap = RxMap<String, SimpleAccountEntity>({});

  final count = 0.obs;

  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId: lastPostId);
    });
    ever(viewerIdList, (_) {
      pagingController.value = PagingState(
        nextPageKey: lastCursor,
        itemList: viewerIdList,
      );
    });
    super.onInit();
  }

  @override
  void onReady() async {
    try {
      isLoading.value = true;

      if (!isMe) {
        await APIProvider.to.patch("/post/posts/$_postId",
            body: {"viewed_count_action": "increase_one"});
      }
    } catch (e) {
      UIUtils.showError(e);
    }
    isLoading.value = false;

    super.onReady();
  }

  void increment() => count.value++;

  Future<List<String>> fetchPage({
    bool replace = false,
    String? lastPostId,
  }) async {
    if (isReachListEnd) {
      pagingController.value = PagingState(
        nextPageKey: null,
        itemList: viewerIdList,
      );
      return [];
    }
    if (isLoading.value == false) {
      isLoading.value = true;

      List<String> indexes = [];
      try {
        final result = await getRawVisitorList(_postId, after: lastPostId);
        if (_isInitial.value == false) {
          _isInitial.value = true;
          if (result.isEmpty) {
            pagingController.value = PagingState(
              nextPageKey: null,
              itemList: [],
            );
          }
        }
        indexes = result;
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
        UIUtils.showError(e);
        return indexes;
      }

      final isLastPage = indexes.length < DEFAULT_PAGE_SIZE;
      if (isLastPage) {
        _isReachListEnd.value = true;
      }

      return indexes;
    } else {
      return [];
    }
  }

  Future<List<String>> getRawVisitorList(String postId,
      {String? before, String? after}) async {
    Map<String, dynamic> query = {};

    if (after != null) {
      query["after"] = after;
    }
    if (before != null) {
      query["before"] = before;
    }
    final result =
        await APIProvider.to.get("/post/posts/$postId/views", query: query);

    final List<String> indexes = [];

    for (var i = 0; i < result["data"].length; i++) {
      final item = result["data"][i];
      final viewerId = item["attributes"]["viewed_by"];
      indexes.add(viewerId);
    }
    if (result["included"] != null) {
      for (var v in result["included"]) {
        if (v["type"] == "accounts") {
          viewerIdMap[v["id"]] = SimpleAccountEntity.fromJson(v["attributes"]);
        }
      }
      viewerIdList.addAll(indexes);
      return indexes;
    }
    if (result["meta"]["page_info"]["end"] != null) {
      lastCursor = result["meta"]["page_info"]["end"];
    }
    return [];
  }

  onDeletePost(id) async {
    await APIProvider.to.delete('/post/posts/$id');
    HomeController.to.myPostsIndexes.remove(id);
    HomeController.to.pageState['home']!.postIndexes.remove(id);
    HomeController.to.pageState['nearby']!.postIndexes.remove(id);
  }

  postChange({required String type, required String postId}) async {
    String _title;
    if (type != 'promote') {
      _visibility.value = type;
      _title = 'visibility';
    } else {
      _title = 'promote';
    }
    final result = await APIProvider.to.patch('/post/posts/$postId',
        body: {_title: type == 'promote' ? true : type});
    HomeController.to.postMap[postId] =
        PostEntity.fromJson(result['data']['attributes']);
  }
}
