import 'package:chat/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/styles/styles.dart';
import 'package:get/get.dart';
import 'package:chat/app/res/strings.dart';
import '../controllers/message_controller.dart';
import 'package:chat/app/widgets/touch_close_keyboard.dart';
import './conversation_item.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';

class MessageView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    final _chatProvider = ChatProvider.to;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey[300]!,
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(0)),
        title: Obx(() => Text(
              controller.isLoadingRooms
                  ? "Loading..."
                  : _chatProvider.isConnected
                      ? "Chats"
                      : "连接失败",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !_chatProvider.isConnected && !controller.isLoadingRooms
                        ? IconButton(
                            icon: Text("🔄"),
                            onPressed: () async {
                              await _chatProvider.connect();
                            },
                          )
                        : Container(),
                  ],
                )),
          ),
          Expanded(
              child: Obx(() => CustomScrollView(
                    slivers: [
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                              onTap: () async {
                                await controller.toRoom(index);
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Obx(() {
                                final room = controller
                                    .entities[controller.indexes[index]]!;
                                SimpleAccountEntity? roomInfo;
                                var name = jidToName(room.id);
                                String? avatar;
                                if (room.room_info_id != null) {
                                  roomInfo = AuthProvider
                                      .to.simpleAccountMap[room.room_info_id];
                                  name = roomInfo?.name ?? name;
                                  avatar = roomInfo?.avatar;
                                }

                                return conversationItemView(
                                    onTap: (index) {
                                      controller.toRoom(index);
                                    },
                                    context: context,
                                    index: index,
                                    id: room.room_info_id ?? '',
                                    name: name,
                                    preview: room.preview,
                                    updatedAt: room.updatedAt,
                                    unreadCount: room.clientUnreadCount,
                                    avatar: avatar);
                              }));
                        },
                        childCount: controller.indexes.length,
                      )),
                    ],
                  ))),
        ],
      ),
    );
  }
}
