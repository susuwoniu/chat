import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/message_controller.dart';
import './conversation_item.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';

class MessageView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    final _chatProvider = ChatProvider.to;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              height: 0.5,
              color: Colors.grey.shade400,
            ),
            preferredSize: Size.fromHeight(0)),
        title: Obx(() => Text(
              controller.isLoadingRooms || !controller.isInitRooms
                  ? "Loading..."
                  : _chatProvider.isConnected
                      ? "Chats".tr
                      : "连接失败",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
        centerTitle: true,
      ),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Container(
              color: Colors.black.withOpacity(0.06),
              // child: Container(color: Colors.red, height: 50)
              child: !_chatProvider.isConnected &&
                      controller.isInitRooms &&
                      !controller.isLoadingRooms
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white38,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shadowColor: Colors.white38,
                              textStyle: TextStyle(color: Colors.black)),
                          onPressed: () async {
                            controller.setIsLoading(true);
                            try {
                              await _chatProvider.connect();
                              controller.setIsLoading(false);
                            } catch (e) {
                              UIUtils.showError(e);
                              controller.setIsLoading(false);
                            }
                          },
                          icon: Icon(Icons.refresh,
                              color: Colors.black, size: 18),
                          label: Text("重试",
                              style: TextStyle(color: Colors.black))))
                  : SizedBox.shrink(),
            )),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Obx(() {
                  final room = controller.entities[controller.indexes[index]]!;
                  SimpleAccountEntity? roomInfo;
                  var name = jidToName(room.id);
                  String? avatar;
                  if (room.room_info_id != null) {
                    roomInfo =
                        AuthProvider.to.simpleAccountMap[room.room_info_id];
                    name = roomInfo?.name ?? name;
                    avatar = roomInfo?.avatar;
                  }

                  return conversationItemView(
                      onTap: (index) {
                        controller.toRoom(index);
                      },
                      isLast: index == controller.entities.length - 1,
                      context: context,
                      index: index,
                      id: room.room_info_id ?? '',
                      name: name,
                      preview: room.preview,
                      updatedAt: room.updatedAt,
                      unreadCount: room.clientUnreadCount,
                      avatar: avatar,
                      likeCount: roomInfo?.like_count ?? 0);
                });
              },
              childCount: controller.indexes.length,
            )),
          ],
        ),
      ),
    );
  }
}
