import 'package:get/get.dart';
import 'package:chat/types/types.dart';
import 'package:chat/app/modules/main/controllers/bottom_navigation_bar_controller.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';

class PostsResult {
  final Map<String, PostEntity> postMap;
  final List<String> indexes;
  final String? endCursor;
  PostsResult({
    this.postMap = const {},
    this.indexes = const [],
    this.endCursor,
  });
}

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final isHomeInitial = false.obs;
  final isMeInitial = false.obs;

  final currentIndex = RxInt(0);
  final postIndexes = RxList<String>([]);
  final myPostsIndexes = RxList<String>([]);

  final isLoading = true.obs;
  final isLoadingMyPosts = true.obs;

  final currentEndCursor = ''.obs;
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

    if (body["meta"]["page_info"]["end"] != null) {
      newEndCursor = body["meta"]["page_info"]["end"];
    }
    return PostsResult(
        postMap: newPostMap, indexes: newIndexes, endCursor: newEndCursor);
  }

  getHomePosts({String? after}) async {
    final result = await getRawPosts(after: after, url: "/post/posts");
    postMap.addAll(result.postMap);
    postIndexes.addAll(result.indexes);

    isLoadingMyPosts.value = false;
    if (isHomeInitial.value == false) {
      isHomeInitial.value = true;
    }
    PatchPostCountView(result.indexes[0]);
  }

  getMePosts({String? after}) async {
    final result = await getRawPosts(after: after, url: "/post/me/posts");
    postMap.addAll(result.postMap);
    myPostsIndexes.addAll(result.indexes);

    isLoadingMyPosts.value = false;
    if (isMeInitial.value == false) {
      isMeInitial.value = true;
    }
  }

  insertEntity() async {}

  void setIndex(int index) {
    currentIndex.value = index;

    final backgroundColor = currentIndex.value == -1
        ? "#FFFFFF"
        : postMap[postIndexes[currentIndex.value]]!.backgroundColor;
    print("backgroundColor $backgroundColor");
    BottomNavigationBarController.to.changeBackgroundColor(backgroundColor);

    if (postIndexes.length - index < 3) {
      if (!isLoading.value && isDataEmpty.value == false) {
        isLoading.value = true;
        getHomePosts(after: currentEndCursor.value);
      }
    }
  }

  void PatchPostCountView(postId) async {
    if (AuthProvider.to.account.value.accountId == postMap[postId]!.accountId) {
      await APIProvider().patch("/post/posts/$postId",
          body: {"viewed_count_action": "increase_one"});
    }
  }

  Future<void> getRawVisitorList(String postId, {String? after}) async {
    Map<String, dynamic> query = {};
    if (after != null) {
      query["after"] = after;
    }
    final body =
        await APIProvider().get("/post/posts/$postId/views", query: query);
    if (body["data"].length == 0) {
      return;
    }
    final Map<String, SimpleAccountEntity> newAccountMap = {};
    final List<String> newIndexes = [];

    // String? newEndCursor;
    for (var i = 0; i < body["data"].length; i++) {
      final item = body["data"][i];
      final viewerId = item["attributes"]["viewed_by"];

      newAccountMap[item["id"]] =
          SimpleAccountEntity(accountId: viewerId, avatar: '', name: 'xxxxjkj');
      newIndexes.add(viewerId);
    }
    AuthProvider.to.simpleAccountMap.addAll(newAccountMap);

    var post = postMap[postId];
    if (post != null) {
      post.views = newIndexes;
      postMap[postId] = post;
    }
    // if (body["meta"]["page_info"]["end"] != null) {
    //   newEndCursor = body["meta"]["page_info"]["end"];
    // }
    // return PostsResult(
    //     postMap: newPostMap, indexes: newIndexes, endCursor: newEndCursor);
  }
}
