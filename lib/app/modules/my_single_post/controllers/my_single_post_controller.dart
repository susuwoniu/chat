import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../me/controllers/me_controller.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/common.dart';
import 'package:chat/app/providers/providers.dart';

import 'dart:async';

class MySinglePostController extends GetxController
    with StateMixin<PostEntity> {
  static MySinglePostController get to => Get.find();

  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  late String postId;
  // final id = ''.obs;
  final _isMe = false.obs;
  bool get isMe => _isMe.value;
  final _visibility = "public".obs;
  String get visibility => _visibility.value;

  final isLoading = false.obs;

  final isLoadingList = false.obs;

  final _isInitial = false.obs;
  bool get isInitial => _isInitial.value;

  var toFetchFirstPage = false;

  final _isListInitial = false.obs;
  bool get isListInitial => _isListInitial.value;

  final _isReachListEnd = false.obs;
  bool get isReachListEnd => _isReachListEnd.value;

  String? lastCursor;

  final viewerIdList = RxList<String>([]);
  final viewerIdMap = RxMap<String, SimpleAccountEntity>({});

  final count = 0.obs;
  late bool isShowReply;
  @override
  void onInit() {
    postId = Get.arguments['id'];
    isShowReply = Get.arguments['is_show_reply'] == 'false' ? false : true;
    pagingController.addPageRequestListener((lastPostId) {
      if (!isInitial) {
        toFetchFirstPage = true;
        return;
      }
      if (AuthProvider.to.isLogin && isMe) {
        fetchPage(lastPostId: lastPostId);
      } else {
        pagingController.value = PagingState(
          nextPageKey: null,
          itemList: [],
        );
      }
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
    super.onReady();

    try {
      isLoading.value = true;

      if (postId != null && HomeController.to.postMap[postId] != null) {
        // do nothing
      } else {
        // get post
        final result = await APIProvider.to.get('/post/posts/$postId');
        HomeController.to.postMap[postId] =
            PostEntity.fromJson(result['data']['attributes']);
      }
      _isMe.value = HomeController.to.postMap[postId]!.accountId ==
          AuthProvider.to.accountId;
      _visibility.value = HomeController.to.postMap[postId]!.visibility;
      _isInitial.value = true;
      super.change(HomeController.to.postMap[postId],
          status: RxStatus.success());
      if (toFetchFirstPage) {
        if (AuthProvider.to.isLogin && isMe) {
          fetchPage(lastPostId: null);
        } else {
          pagingController.value = PagingState(
            nextPageKey: null,
            itemList: [],
          );
        }
      }
      if (AuthProvider.to.isLogin && !isMe) {
        await APIProvider.to.patch("/post/posts/$postId",
            body: {"viewed_count_action": "increase_one"});
      }
    } catch (e) {
      super.change(null, status: RxStatus.error(e.toString()));
      UIUtils.showError(e);
    }
    isLoading.value = false;
    super.update();
  }

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
    if (isLoadingList.value == false) {
      isLoadingList.value = true;

      List<String> indexes = [];
      try {
        final result = await getRawVisitorList(postId, after: lastPostId);
        if (_isListInitial.value == false) {
          _isListInitial.value = true;
          if (result.isEmpty) {
            pagingController.value = PagingState(
              nextPageKey: null,
              itemList: [],
            );
          }
        }
        indexes = result;
        isLoadingList.value = false;
      } catch (e) {
        isLoadingList.value = false;
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
    MeController.to.myPostsIndexes.remove(id);
    HomeController.to.pageState['home']!.postIndexes.remove(id);
    HomeController.to.pageState['nearby']!.postIndexes.remove(id);
    final _account = AuthProvider.to.account;
    _account.update((value) {
      if (value != null) {
        value.post_count = _account.value.post_count - 1;
      }
    });
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
