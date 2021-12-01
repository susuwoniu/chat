import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../controllers/room_controller.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';

class RoomView extends GetView<RoomController> {
  @override
  Widget build(BuildContext context) {
    final messageController = MessageController.to;
    final roomId = controller.roomId;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final room = messageController.entities[roomId];
          return room != null && room.isLoading
              ? Text("loading")
              : Text('ChatView');
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        final room = messageController.entities[roomId];
        return Chat(
          messages: messageController.roomMessageIndexesMap[roomId] != null
              ? messageController.roomMessageIndexesMap[roomId]!
                  .map<types.Message>(
                      (id) => messageController.messageEntities[id]!)
                  .toList()
              : [],
          emptyState: room != null && room.isLoading
              ? Text("isLoading")
              : Text("No message yet"),
          onSendPressed: controller.handleSendPressed,
          onEndReached: controller.handleEndReached,
          user: controller.user!,
        );
      }),
    );
  }
}
