import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../controllers/chat_controller.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';

class ChatView extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    final roomId = controller.roomId;
    final messageController = MessageController.to;

    return Obx(() {
      final room = messageController.entities[roomId]!;
      return Scaffold(
        appBar: AppBar(
          title: room.isLoading ? Text("loading") : Text('ChatView'),
          centerTitle: true,
        ),
        body: Chat(
          // messages: controller.indexes.reversed.map((id) {
          //   return controller.entities[id]!;
          // }).toList(),
          messages: messageController.roomMessageIndexesMap[roomId]!.reversed
              .map((id) {
            final types.Message message =
                messageController.messageEntities[id]!;
            return message;
          }).toList(),
          onSendPressed: controller.handleSendPressed,
          user: controller.user!,
        ),
      );
    });
  }
}
