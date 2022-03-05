import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/message_controller.dart';
import './conversation_item.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class MessageView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    final _chatProvider = ChatProvider.to;
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            bottom: PreferredSize(
                child: Container(
                  height: 0.5,
                  color: Theme.of(context).dividerColor,
                ),
                preferredSize: Size.fromHeight(0)),
            actions: [
              IconButton(
                splashColor: Colors.transparent,
                icon: Icon(Icons.close, size: 26),
                onPressed: () {
                  _chatProvider.closeConnection();
                },
              )
            ],
            title: Obx(() => Text(
                  (controller.isLoadingRooms &&
                              _chatProvider.connectionState ==
                                  xmpp.ConnectionState.connecting) ||
                          !controller.isInitRooms
                      ? "Connecting...".tr
                      : (_chatProvider.connectionState ==
                                  xmpp.ConnectionState.connected ||
                              _chatProvider.connectionState ==
                                  xmpp.ConnectionState.resumed)
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
                // SliverToBoxAdapter(
                //     floating: false,
                //      pinned: false,
                //     child: Container(
                //   padding:
                //       EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 0),
                //   decoration: BoxDecoration(
                //       border: Border(
                //           bottom: BorderSide(
                //               color: Theme.of(context).dividerColor,
                //               width: 0.5))),
                //   child: Container(
                //       width: double.infinity,
                //       height: 42,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(30),
                //           color: Theme.of(context).colorScheme.background),
                //       child: TextField(
                //           decoration: InputDecoration(
                //         hintText: 'Search for something',
                //         prefixIcon: Icon(Icons.search),
                //         border: InputBorder.none,
                //       ))),
                // )),
                SliverToBoxAdapter(
                    child: Container(
                  color: Theme.of(context).colorScheme.background,
                  // child: Container(color: Colors.red, height: 50)
                  child: (_chatProvider.connectionState ==
                              xmpp.ConnectionState.disconnected) &&
                          controller.isInitRooms
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white38,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shadowColor: Colors.white38,
                                  textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground)),
                              onPressed: () async {
                                controller.setIsLoading(true);
                                try {
                                  await _chatProvider.reconnect();
                                  // controller.setIsLoading(false);
                                } catch (e) {
                                  UIUtils.showError(e);
                                  controller.setIsLoading(false);
                                }
                              },
                              icon: Icon(Icons.refresh,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
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
                      final room =
                          controller.entities[controller.indexes[index]]!;
                      SimpleAccountEntity? roomInfo;
                      var name = jidToName(room.id);
                      String? avatar;
                      if (room.room_info_id != null) {
                        roomInfo =
                            AuthProvider.to.simpleAccountMap[room.room_info_id];
                        name = roomInfo?.name ?? name;
                        avatar = roomInfo?.avatar?.thumbnail.url;
                      }

                      return ConversationItemView(
                          onTap: controller.toRoom,
                          onDismiss: controller.onDismiss,
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
                SliverToBoxAdapter(child: Container(height: 110))
              ],
            ),
          ),
        ));
  }
}
