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
          title: Text('ProfileViewersView'.tr),
          centerTitle: true,
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Colors.grey.shade400,
              ),
              preferredSize: Size.fromHeight(0)),
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
                : Center(
                    child: Column(children: [
                      SizedBox(height: 20),
                      Icon(
                        Icons.lunch_dining_rounded,
                        color: Colors.yellow.shade700,
                        size: 60,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No_one_has_been_here.'.tr,
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ]),
                  ))));
  }
}
