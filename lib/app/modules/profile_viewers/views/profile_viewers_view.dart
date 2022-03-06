import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../controllers/profile_viewers_controller.dart';
import 'single_viewer.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:chat/common.dart';

class ProfileViewersView extends GetView<ProfileViewersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          title: Text('ProfileViewersView'.tr, style: TextStyle(fontSize: 16)),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: RefreshIndicator(
            backgroundColor: Theme.of(context).colorScheme.surface,
            onRefresh: () => Future.sync(
                  () {},
                ),
            child: SafeArea(
              child: PagedListView(
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<String>(
                      noItemsFoundIndicatorBuilder: (BuildContext context) {
                    return Empty();
                  }, itemBuilder: (context, id, index) {
                    return SingleViewer(
                        onPressed: () {
                          Get.toNamed(Routes.OTHER, arguments: {"id": id});
                        },
                        isLast:
                            index == controller.profileViewerIdList.length - 1,
                        viewerAccount: controller.profileViewerMap[id]!);
                  })),
            )));
  }
}
