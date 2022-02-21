import 'package:chat/app/providers/providers.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/common.dart';

class StarController extends GetxController {
  static StarController get to => Get.find();
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  final _isInitial = false.obs;
  bool get isInitial => _isInitial.value;

  String? lastCursor;

  final postIndexes = RxList<String>([]);
  final favoriteMap = RxMap<String, FavoriteEntity>({});
  final postMap = RxMap<String, PostEntity>({});

  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId: lastPostId);
    });
    super.onInit();
  }

  Future<List<String>> fetchPage({
    bool replace = false,
    String? lastPostId,
  }) async {
    List<String> indexes = [];

    try {
      final result = await getFavoritePosts(after: lastPostId);
      if (_isInitial.value == false) {
        _isInitial.value = true;
      }
      indexes = result.indexes;
      favoriteMap.addAll(result.favoriteMap);
      postMap.addAll(result.postMap);
      AuthProvider.to.simpleAccountMap.addAll(result.accountMap);
      postIndexes.addAll(indexes);

      if (indexes.isNotEmpty) {
        lastCursor = result.endCursor;
      }
      final isLastPage = indexes.isEmpty;
      if (isLastPage) {
        pagingController.appendLastPage(indexes);
      } else {
        final nextPageKey = result.endCursor;
        pagingController.appendPage(indexes, nextPageKey);
      }
    } catch (e) {
      UIUtils.showError(e);
      return indexes;
    }

    return indexes;
  }
}
