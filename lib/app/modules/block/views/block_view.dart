import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/block_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/app/common/block.dart';
import '../../my_single_post/views/post_single_viewer.dart';
import 'package:chat/common.dart';

// TODO use constans or config
class BlockView extends GetView<BlockController> {
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
          title: Text('Blocked_List'.tr, style: TextStyle(fontSize: 16)),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            backgroundColor: Theme.of(context).colorScheme.surface,
            onRefresh: () => Future.sync(
              () => controller.pagingController.refresh(),
            ),
            child: PagedListView(
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<String>(
                    noItemsFoundIndicatorBuilder: (BuildContext context) {
                  return Empty();
                }, itemBuilder: (context, id, index) {
                  final account = controller.blockMap[id];
                  if (account == null) {
                    return SizedBox.shrink();
                  }
                  return Obx(() => PostSingleViewer(
                      onPressedUnblock: () async {
                        try {
                          await toggleBlock(id: id, toBlocked: false);
                          controller.blockIdList.remove(id);
                        } catch (e) {
                          UIUtils.showError(e);
                        }
                      },
                      isBlock: true,
                      isLast: index == controller.blockIdList.length - 1,
                      name: account.name,
                      img: account.avatar?.thumbnail.url,
                      likeCount: account.like_count,
                      id: id,
                      isVip: account.vip,
                      margin: 15,
                      iconSize: 28));
                })),
          ),
        ));
  }
}
