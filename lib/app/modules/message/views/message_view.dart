import 'package:chat/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/message_controller.dart';

class MessageView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title:
              Text("message".tr, style: Theme.of(context).textTheme.bodyText1),
          leading: IconButton(
            icon: Icon(
              Icons.settings,
              color: IconTheme.of(context).color,
            ),
            onPressed: () {
              Get.toNamed(Routes.SETTING);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: IconTheme.of(context).color,
              ),
              onPressed: () {
                Get.toNamed(Routes.SETTING);
              },
            )
          ]),
      body: Center(
        child: Column(
          children: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: IconTheme.of(context).color,
              ),
              onPressed: () {
                Get.toNamed(Routes.TEST1);
              },
            ),
            Text(
              'MessageView is working',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
