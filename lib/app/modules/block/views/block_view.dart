import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../controllers/block_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../other/controllers/other_controller.dart';
import 'single_block.dart';

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
        title: Text('Block_list'.tr, style: TextStyle(fontSize: 17)),
        centerTitle: true,
      ),
      body: PagedListView(
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<String>(
              itemBuilder: (context, id, index) {
            return SingleBlock(
                onPressed: () {
                  Get.toNamed(Routes.OTHER, arguments: {"accountId": id});
                },
                onPressedUnblock: () {
                  try {
                    OtherController.to
                        .accountAction(isLiked: false, increase: false);
                  } catch (e) {
                    UIUtils.showError(e);
                  }
                },
                isLast: index == controller.blockIdList.length - 1,
                blockAccount: controller.blockMap[id]!);
          })),
    );
  }
}
