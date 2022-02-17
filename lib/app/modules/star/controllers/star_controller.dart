import 'package:chat/app/providers/providers.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/common.dart';

class StarController extends GetxController {
  static StarController get to => Get.find();
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  final isLoading = false.obs;

  final _isInitial = false.obs;
  bool get isInitial => _isInitial.value;

  final _isReachListEnd = false.obs;
  bool get isReachListEnd => _isReachListEnd.value;

  String? lastCursor;

  final count = 0.obs;
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

  @override
  onReady() {
    super.onReady();
  }

  Future<List<String>> fetchPage({
    bool replace = false,
    String? lastPostId,
  }) async {
    if (isLoading.value == false) {
      isLoading.value = true;

      List<String> indexes = [];

      try {
        final result = await getFavoritePosts(after: lastPostId);
        if (_isInitial.value == false) {
          _isInitial.value = true;
        }
        indexes = result.indexes;
        favoriteMap.addAll(result.favoriteMap);
        // postMap.addAll(result.postMap);
        // AuthProvider.to.simpleAccountMap.addAll(result.accountMap);
        // postIndexes.addAll(indexes);

        if (indexes.isNotEmpty) {
          lastCursor = result.endCursor;
        }
        final isLastPage = indexes.length < DEFAULT_PAGE_SIZE;
        if (isLastPage) {
          _isReachListEnd.value = true;
          pagingController.appendLastPage(indexes);
        } else {
          final nextPageKey = result.endCursor;
          pagingController.appendPage(indexes, nextPageKey);
        }
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;

        UIUtils.showError(e);
        return indexes;
      }

      return indexes;
    } else {
      return [];
    }
  }
}
