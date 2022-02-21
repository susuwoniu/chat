import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/common.dart';
import '../../post/controllers/post_controller.dart';

class ExploreController extends GetxController {
  //TODO: Implement AboutController
  static ExploreController get to => Get.find();
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);
  var postTemplatesMap = RxMap<String, PostTemplatesEntity>({});

  @override
  void onInit() {
    pagingController.addPageRequestListener((lastPostId) {
      fetchPage(lastPostId: lastPostId);
    });
    super.onInit();
  }

  Future<void> fetchPage({
    String? lastPostId,
  }) async {
    List<String> indexes = [];
    try {
      final result = await getRawPostTemplates(after: lastPostId);
      postTemplatesMap.addAll(result.postTemplatesMap);
      indexes = result.postTemplatesIndexes;
      final isLastPage = indexes.isEmpty;
      if (isLastPage) {
        pagingController.appendLastPage(indexes);
      } else {
        pagingController.appendPage(indexes, result.endCursor);
      }
    } catch (e) {
      UIUtils.showError(e);
      pagingController.error(e);
    }
  }
}
