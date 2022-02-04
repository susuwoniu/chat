import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/block_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'single_block.dart';
import 'package:chat/app/common/block.dart';

// TODO use constans or config
class BlockView extends GetView<BlockController> {
  final PagingController<String?, String> pagingController =
      PagingController(firstPageKey: null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Colors.grey.shade400,
              ),
              preferredSize: Size.fromHeight(0)),
          title: Text('Blocked_Users'.tr, style: TextStyle(fontSize: 16)),
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => controller.pagingController.refresh(),
          ),
          child: PagedListView(
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<String>(
                  itemBuilder: (context, id, index) {
                return SingleBlock(
                    onPressedUnblock: () async {
                      try {
                        await toggleBlock(id: id, toBlocked: false);
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    },
                    id: id,
                    isLast: index == controller.blockIdList.length - 1,
                    blockAccount: controller.blockMap[id]!);
              })),
        ));
  }
}
