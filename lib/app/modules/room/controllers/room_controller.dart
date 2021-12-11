import 'package:chat/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'dart:convert';
import 'dart:math';
import 'dart:async';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid
String randomString() {
  var random = Random.secure();
  var values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class RoomController extends GetxController {
  late String _roomId;
  String get roomId => _roomId;
  String? _postId;
  String? get postId => _postId;
  types.TextMessage? _previewMessage;
  types.TextMessage? get previewMessage => _previewMessage;
  StreamSubscription<ConnectionState>? _chatConnectionUpdatedSubscription;

  @override
  void onInit() {
    final pageArguments = Get.arguments;
    if (pageArguments["id"] != null && pageArguments["id"] is String) {
      _roomId = pageArguments["id"];
    }
    if (pageArguments["post_id"] != null &&
        pageArguments["post_id"] is String) {
      _postId = pageArguments["post_id"];
    }
    _chatConnectionUpdatedSubscription =
        ChatProvider.to.connectionUpdated.listen((event) {
      if (event == ConnectionState.connected) {
        init();
      } else if (event == ConnectionState.disconnected) {
        // 断开连接，清空房间列表
        dipose();
      }
    });
    if (ChatProvider.to.currentChatAccount.value != null) {
      init();
    }

    super.onInit();
  }

  void init() {
    final messageController = MessageController.to;

    messageController.setCurrentRoomId(_roomId);
    final homeController = HomeController.to;
    if (_postId != null &&
        homeController.postMap[_postId] != null &&
        ChatProvider.to.currentChatAccount.value != null) {
      _previewMessage = types.TextMessage(
          text: homeController.postMap[_postId]!.content,
          author: ChatProvider.to.currentChatAccount.value!,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: "preview");
    }
  }

  @override
  void onReady() async {
    final messageController = MessageController.to;
    messageController.markRoomAsRead(_roomId);
    final room = messageController.getCurrentRoom();
    if (room != null && !room.isInitServerMessages) {
      try {
        await MessageController.to.getRoomServerEarlierMessage(_roomId);
      } catch (e) {
        print(e);
      }
    }

    super.onReady();
  }

  void dipose() {
    if (_chatConnectionUpdatedSubscription != null) {
      _chatConnectionUpdatedSubscription!.cancel();
    }
  }

  @override
  void onClose() async {
    dipose();
    final messageController = MessageController.to;
    messageController.setCurrentRoomId(null);
    super.onClose();
  }

  Future<void> handleEndReached() async {
    final messageController = MessageController.to;
    await messageController.getRoomServerEarlierMessage(_roomId);
  }

  Future<void> handleSendPressed(types.PartialText message) async {
    final messageController = MessageController.to;
    // check is has preview message
    try {
      if (_previewMessage != null) {
        messageController.sendTextMessage(
            _roomId,
            types.PartialText(
              text: _previewMessage!.text,
            ));
        _previewMessage = null;
        messageController.sendTextMessage(_roomId, message);
      } else {
        messageController.sendTextMessage(_roomId, message);
      }
    } catch (e) {
      rethrow;
    }
  }
}
