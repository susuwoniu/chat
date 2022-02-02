import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/liked_me_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../block/views/single_block.dart';
import 'package:chat/app/common/block.dart';

// TODO use constans or config
class LikedMeView extends GetView<LikedMeController> {
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
            title: Text('Who_Liked_Me'.tr, style: TextStyle(fontSize: 17)),
            centerTitle: true),
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
                    isBlock: false,
                    id: id,
                    isLast: index == controller.likedIdList.length - 1,
                    blockAccount: controller.likedMap[id]!);
              })),
        ));
  }
}
