import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../controllers/profile_viewers_controller.dart';
import 'single_viewer.dart';

class ProfileViewersView extends GetView<ProfileViewersController> {
  @override
  Widget build(BuildContext context) {
    final _paddingLeft = MediaQuery.of(context).size.width * 0.04;
    return Scaffold(
        appBar: AppBar(
          title: Text('ProfileViewersView'),
          centerTitle: true,
        ),
        body: Obx(() => SingleChildScrollView(
              child: controller.profileViewerIdList.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: _paddingLeft),
                      child: Column(
                          children: controller.profileViewerIdList.map((id) {
                        return SingleViewer(
                            onPressed: () {
                              Get.toNamed(Routes.OTHER,
                                  arguments: {"accountId": id});
                            },
                            viewerAccount: controller.profileViewerMap[id]!);
                      }).toList()))
                  : SizedBox.shrink(),
            )));
  }
}
