import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/message_controller.dart';
import './conversation_item.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;
import 'package:flutter/services.dart';

class MessageView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    final _chatProvider = ChatProvider.to;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light), // 1
        bottom: PreferredSize(
            child: Container(
              height: 0.5,
              color: Theme.of(context).dividerColor,
            ),
            preferredSize: Size.fromHeight(0)),
        title: Obx(() => Text(
              controller.isLoadingRooms || !controller.isInitRooms
                  ? "Loading...".tr
                  : _chatProvider.connectionState ==
                          xmpp.ConnectionState.connected
                      ? "Chats".tr
                      : "Network_error".tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )),
      ),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Container(
              color: Theme.of(context).colorScheme.background,
              // child: Container(color: Colors.red, height: 50)
              child: (_chatProvider.connectionState ==
                              xmpp.ConnectionState.connecting ||
                          _chatProvider.connectionState ==
                              xmpp.ConnectionState.disconnected) &&
                      controller.isInitRooms &&
                      !controller.isLoadingRooms
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white38,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shadowColor: Colors.white38,
                              textStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                          onPressed: () async {
                            controller.setIsLoading(true);
                            try {
                              await _chatProvider.reconnect();
                              controller.setIsLoading(false);
                            } catch (e) {
                              UIUtils.showError(e);
                              controller.setIsLoading(false);
                            }
                          },
                          icon: Icon(Icons.refresh,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: 18),
                          label: Text("重试",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground))))
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
