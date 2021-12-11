import 'package:get/get.dart';
import 'package:chat/types/types.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';

class PostsResult {
  final Map<String, PostEntity> postMap;
  final Map<String, SimpleAccountEntity> accountMap;
  final List<String> indexes;
  final String? endCursor;
  PostsResult({
    this.postMap = const {},
    this.indexes = const [],
    this.endCursor,
    this.accountMap = const {},
  });
}

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final isHomeInitial = false.obs;
  final isMeInitial = false.obs;

  final currentIndex = RxInt(0);
  final postIndexes = RxList<String>([]);
  final myPostsIndexes = RxList<String>([]);

  final isLoadingHomePosts = true.obs;
  final isLoadingMyPosts = true.obs;

  final currentEndCursor = RxnString();
  final isDataEmpty = false.obs;

  final postMap = RxMap<String, PostEntity>({});

  final postTemplatesIndexes = RxList<String>([]);
  final postTemplatesMap = RxMap<String, PostTemplatesEntity>({});

  @override
  void onReady() async {
    try {
      await getHomePosts();
    } catch (e) {
      UIUtils.showError(e);
    }
    super.onReady();
  }

  Future<PostsResult> getRawPosts({String? after, required String url}) async {
    Map<String, dynamic> query = {};
    if (after != null) {
      query["after"] = after;
    }
    final body = await APIProvider().get(url, query: query);
    if (body["data"].length == 0) {
      return PostsResult();
    }
    final Map<String, PostEntity> newPostMap = {};
    final List<String> newIndexes = [];
    String? newEndCursor;
    for (var i = 0; i < body["data"].length; i++) {
      final item = body["data"][i];
      newPostMap[item["id"]] = PostEntity.fromJson(item["attributes"]);
      newIndexes.add(item["id"]);
    }
    final Map<String, SimpleAccountEntity> newAccountMap = {};
    if (body["included"] != null) {
      for (var v in body["included"]) {
        if (v["type"] == "accounts") {
          newAccountMap[v["id"]] =
              SimpleAccountEntity.fromJson(v["attributes"]);
        }
      }
    }

    if (body["meta"]["page_info"]["end"] != null) {
      newEndCursor = body["meta"]["page_info"]["end"];
    }
    return PostsResult(
        postMap: newPostMap,
        indexes: newIndexes,
        endCursor: newEndCursor,
        accountMap: newAccountMap);
  }

  getHomePosts({String? after}) async {
    final result = await getRawPosts(after: after, url: "/post/posts");
    if (result.indexes.isNotEmpty) {
      postMap.addAll(result.postMap);
      postIndexes.addAll(result.indexes);
      // save current end cursor
      if (result.endCursor != null) {
        currentEndCursor.value = result.endCursor;
      }
      // put accoutns to simple accounts
      await AuthProvider.to.saveSimpleAccounts(result.accountMap);
      PatchPostCountView(result.indexes[0]);
    } else {
      isDataEmpty.value = true;
    }

    isLoadingHomePosts.value = false;
    if (isHomeInitial.value == false) {
      isHomeInitial.value = true;
    }
  }

  getMePosts({String? after}) async {
    final result = await getRawPosts(after: after, url: "/post/me/posts");
    postMap.addAll(result.postMap);
    myPostsIndexes.addAll(result.indexes);
    await AuthProvider.to.saveSimpleAccounts(result.accountMap);

    isLoadingMyPosts.value = false;
    if (isMeInitial.value == false) {
      isMeInitial.value = true;
    }
  }

  insertEntity() async {}

  void setIndex(int index) {
    var backgroundColor = "#FFFFFF";
    if (index >= postIndexes.length) {
      currentIndex.value = -1;
    } else {
      currentIndex.value = index;

      final post = postMap[postIndexes[index]];
      if (post != null) {
        backgroundColor = post.backgroundColor;
        PatchPostCountView(postIndexes[index]).catchError((e) {
          UIUtils.reportError(e);
        });
      }
    }

    BottomNavigationBarController.to.changeBackgroundColor(backgroundColor);

    if (postIndexes.length - index < 3) {
      if (!isLoadingHomePosts.value &&
          isDataEmpty.value == false &&
          currentEndCursor.value != null) {
        isLoadingHomePosts.value = true;
        getHomePosts(after: currentEndCursor.value).then((data) {
          isLoadingHomePosts.value = false;
        }).catchError((e) {
          isLoadingHomePosts.value = false;
          UIUtils.showError(e);
        });
      } else if (isDataEmpty.value) {
        Log.debug("reach post end");
      }
    }
  }

  Future<void> PatchPostCountView(String postId) async {
    if (AuthProvider.to.accountId == postMap[postId]!.accountId) {
      await APIProvider().patch("/post/posts/$postId",
          body: {"viewed_count_action": "increase_one"});
    }
  }

  Future<void> getRawVisitorList(String postId, {String? after}) async {
    var post = postMap[postId];
    if (post != null) {
      post.isLoadingViewersList = true;
      postMap[postId] = post;
    }
    Map<String, dynamic> query = {};
    if (after != null) {
      query["after"] = after;
    }
    final body =
        await APIProvider().get("/post/posts/$postId/views", query: query);

    final Map<String, SimpleAccountEntity> newAccountMap = {};
    final List<String> newIndexes = [];

    // String? newEndCursor;
    for (var i = 0; i < body["data"].length; i++) {
      final item = body["data"][i];
      final viewerId = item["attributes"]["viewed_by"];

      newAccountMap[viewerId] =
          SimpleAccountEntity(avatar: '', name: 'xxxxjkj');
      newIndexes.add(viewerId);
    }
    AuthProvider.to.saveSimpleAccounts(newAccountMap);

    if (post != null) {
      post.views = newIndexes;
      post.isLoadingViewersList = false;
      postMap[postId] = post;
    }
    // if (body["meta"]["page_info"]["end"] != null) {
    //   newEndCursor = body["meta"]["page_info"]["end"];
    // }
    // return PostsResult(
    //     postMap: newPostMap, indexes: newIndexes, endCursor: newEndCursor);
  }
}
