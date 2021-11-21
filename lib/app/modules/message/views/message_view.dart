import 'package:chat/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/styles/styles.dart';
import 'package:get/get.dart';
import 'package:chat/app/res/strings.dart';
import '../controllers/message_controller.dart';
import 'package:chat/app/widges/touch_close_keyboard.dart';
import './conversation_item.dart';

class MessageView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("message"),
        centerTitle: true,
      ),
      body: Container(child: Text("test")),
    );
    return Obx(
      () => TouchCloseSoftKeyboard(
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          // appBar: AppBar(),
          appBar: AppBar(
            title: Text('Message'),
            centerTitle: true,
          ),
          body: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) =>
                    GestureDetector(
                        onTap: () => controller.toChat(index),
                        behavior: HitTestBehavior.translucent,
                        child: Text("xx")
                        // child: conversationItemView(
                        //   onTap: (index) {
                        //     controller.toChat(index);
                        //   },
                        //   context: context,
                        //   index: index,
                        //   title: controller.getShowName(index),
                        //   lastMessage: controller.getMsgContent(index),
                        //   updatedAtStr: controller.getTime(index),
                        //   unreadCount: controller.getUnreadCount(index),
                        // )),
                        // childCount: controller.list.length,
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
