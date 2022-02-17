import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';
import '../../post/controllers/post_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../home/controllers/home_controller.dart';

class PostSquareController extends GetxController {
  static PostSquareController get to => Get.find();

  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  final _id = Get.arguments['id'];
  final _usedCount = 0.obs;
  int get usedCount => _usedCount.value;
  final _isInitial = false.obs;
  bool get isInitial => _isInitial.value;
  final _isLoadingPosts = false.obs;
  bool get isLoadingPosts => _isLoadingPosts.value;
  final postIndexes = RxList<String>([]);
  final postMap = RxMap<String, PostEntity>({});
  final _isReachHomePostsEnd = false.obs;
  bool get isReachHomePostsEnd => _isReachHomePostsEnd.value;
  final _homeInitError = "".obs;
  String get homeInitError => _homeInitError.value;
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  final _isDataEmpty = false.obs;
  bool get isDataEmpty => _isDataEmpty.value;
  String? homePostsLastCursor;

  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId: lastPostId);
    });
    super.onInit();
  }

  @override
  onReady() async {
    super.onReady();
    try {
      await getTemplateData();
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  Future<List<String>> fetchPage({
    bool replace = false,
    String? lastPostId,
  }) async {
    if (_isLoadingPosts.value == false) {
      _isLoadingPosts.value = true;

      List<String> indexes = [];

      try {
        final result = await getApiPosts(
            after: lastPostId, url: "/post/posts", postTemplateId: _id);
        if (_isInitial.value == false) {
          _isInitial.value = true;
        }
        indexes = result.indexes;
        postMap.addAll(result.postMap);
        postIndexes.addAll(indexes);
        _isLoadingPosts.value = false;
      } catch (e) {
        _isLoadingPosts.value = false;

        UIUtils.showError(e);
        return indexes;
      }

      final isLastPage = indexes.length < DEFAULT_PAGE_SIZE;
      if (isLastPage) {
        _isReachHomePostsEnd.value = true;
        pagingController.appendLastPage(indexes);
      } else {
        final nextPageKey = indexes.last;
        pagingController.appendPage(indexes, nextPageKey);
      }
      if (indexes.isNotEmpty) {
        homePostsLastCursor = indexes.last;
      }
      return indexes;
    } else {
      return [];
    }
  }

  void refreshHomePosts() {
    fetchPage(replace: true).then((data) {
      if (data.isNotEmpty) {
        setIndex(index: 0);
      }
    }).catchError((e) {
      UIUtils.showError(e);
    });
  }

  void setIndex({required int index}) {
    _currentIndex.value = index;

    if (index >= postIndexes.length) {
      // loading more
    } else {
      final post = postMap[postIndexes[index]];
      if (post != null) {
        HomeController.to
            .patchPostCountView(postId: postIndexes[index])
            .catchError((e) {
          report(e);
        });
      }
    }

    if (postIndexes.length >= 3 && postIndexes.length - index < 3) {
      if (!isLoadingPosts && isDataEmpty == false && !isReachHomePostsEnd) {
        fetchPage(lastPostId: homePostsLastCursor)
            .then((data) {})
            .catchError((e) {
          UIUtils.showError(e);
        });
      } else if (isReachHomePostsEnd && _isLoadingPosts.value == false) {
        Log.debug("reach post end");
      }
    }
  }

  Future<void> patchPostCountView(String postId) async {
    // change last cursor

    if (AuthProvider.to.isLogin &&
        AuthProvider.to.accountId != postMap[postId]!.accountId) {
      await APIProvider.to.patch("/post/posts/$postId",
          body: {"viewed_count_action": "increase_one"});
    }
  }

  getTemplateData() async {
    final result = await APIProvider.to.get('/post/post-templates/$_id');
    _usedCount.value = result['data']['attributes']['used_count'];
    if (PostController.to.postTemplatesMap[_id] == null) {
      PostController.to.postTemplatesMap[_id] =
          PostTemplatesEntity.fromJson(result['data']['attributes']);
    }
  }
}
