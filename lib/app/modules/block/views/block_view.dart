import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../controllers/block_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../profile_viewers/controllers/profile_viewers_controller.dart';
import 'single_block.dart';

// TODO use constans or config
class BlockView extends GetView<BlockController> {
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
        title: Text('Block_list'.tr, style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: PagedListView(
          pagingController: ProfileViewersController.to.pagingController,
          builderDelegate: PagedChildBuilderDelegate<String>(
              itemBuilder: (context, id, index) {
            return SingleBlock(
                onPressed: () {
                  Get.toNamed(Routes.OTHER, arguments: {"accountId": id});
                },
                isLast: index ==
                    ProfileViewersController.to.profileViewerIdList.length - 1,
                viewerAccount:
                    ProfileViewersController.to.profileViewerMap[id]!);
          })),
    );
  }
}
