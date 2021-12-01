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
      body: Column(
        children: [
          Container(
            child: Obx(() => Text(
                  _chatProvider.isLoading
                      ? "Connecting..."
                      : _chatProvider.isConnected
                          ? "Connected"
                          : "连接失败",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                        onTap: () async {
                          await controller.toChat(index);
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Obx(() {
                          final room =
                              controller.entities[controller.indexes[index]]!;
                          return conversationItemView(
                            onTap: (index) {
                              controller.toChat(index);
                            },
                            context: context,
                            index: index,
                            title: room.id,
                            preview: room.preview,
                            updatedAt: room.updatedAt,
                            unreadCount: room.clientUnreadCount,
                          );
                        }));
                  },
                  childCount: controller.indexes.length,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
