import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../controllers/chat_controller.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';

class ChatView extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    final messageController = MessageController.to;
    final roomId = controller.roomId;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final room = messageController.entities[roomId];
          return room!.isLoading ? Text("loading") : Text('ChatView');
        }),
        centerTitle: true,
      ),
      body: Obx(() => Chat(
            messages:
                messageController.roomMessageIndexesMap[roomId]!.map((id) {
              final types.Message message =
                  messageController.messageEntities[id]!;
              return message;
            }).toList(),
            onSendPressed: controller.handleSendPressed,
            onEndReached: controller.handleEndReached,
            user: controller.user!,
          )),
    );
  }
}
