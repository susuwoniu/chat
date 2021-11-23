import 'package:chat/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/styles/styles.dart';
import 'package:get/get.dart';
import 'package:chat/app/res/strings.dart';
import '../controllers/message_controller.dart';
import 'package:chat/app/widges/touch_close_keyboard.dart';
import './conversation_item.dart';
import 'package:chat/app/providers/providers.dart';

class MessageView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    final _chatProvider = ChatProvider.to;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      appBar: AppBar(
        title: Text('Message'),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          children: [
            Container(
              child: Text(
                _chatProvider.isLoading ? "Connecting..." : "Connected",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) => GestureDetector(
                        onTap: () => controller.toChat(index),
                        behavior: HitTestBehavior.translucent,
                        child: conversationItemView(
                          onTap: (index) {
                            controller.toChat(index);
                          },
                          context: context,
                          index: index,
                          title: "user1",
                          lastMessage: "lastMessage",
                          updatedAtStr: "updated at",
                          unreadCount: 1,
                        )),
                    childCount: 1,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
