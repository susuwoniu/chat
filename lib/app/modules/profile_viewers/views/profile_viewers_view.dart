import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_viewers_controller.dart';

import '../../my_single_post/views/viewers_list.dart';
import 'single_day_viewers.dart';

class ProfileViewersView extends GetView<ProfileViewersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ProfileViewersView'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            // child:
            //      SingleDayViewers(
            //   accountMap: controller.userList,
            // ),
            ));
  }
}
