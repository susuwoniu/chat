import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/block_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/app/common/block.dart';
import '../../my_single_post/views/post_single_viewer.dart';

// TODO use constans or config
class BlockView extends GetView<BlockController> {
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
          title: Text('Blocked_Users'.tr, style: TextStyle(fontSize: 16)),
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
                  itemBuilder: (context, id, index) {
                final account = controller.blockMap[id];
                if (account == null) {
                  return SizedBox.shrink();
                }
                return PostSingleViewer(
                    onPressed: () async {
                      try {
                        await toggleBlock(id: id, toBlocked: false);
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    },
                    isBlock: true,
                    isLast: index == controller.blockIdList.length - 1,
                    name: account.name,
                    img: account.avatar,
                    likeCount: account.like_count,
                    viewerId: id,
                    isVip: account.vip,
                    margin: 15,
                    iconSize: 28,
                    fontSize: 15);
              })),
        )));
  }
}
