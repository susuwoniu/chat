import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text('ChatView'),
            centerTitle: true,
          ),
          body: Chat(
            messages: controller.indexes.reversed.map((id) {
              return controller.entities[id]!;
            }).toList(),
            onSendPressed: controller.handleSendPressed,
            user: controller.user!,
          ),
        ));
  }
}
