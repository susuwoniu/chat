import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../controllers/profile_viewers_controller.dart';
import 'single_viewer.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/services.dart';

class ProfileViewersView extends GetView<ProfileViewersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ProfileViewersView'.tr, style: TextStyle(fontSize: 17)),
          centerTitle: true,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Colors.grey.shade400,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(
            () {},
          ),
          child: PagedListView(
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<String>(
                  itemBuilder: (context, id, index) {
                return SingleViewer(
                    onPressed: () {
                      Get.toNamed(Routes.OTHER, arguments: {"accountId": id});
                    },
                    isLast: index == controller.profileViewerIdList.length - 1,
                    viewerAccount: controller.profileViewerMap[id]!);
              })),
        ));
  }
}
