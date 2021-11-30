import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:convert';
import 'dart:math';
import 'package:chat/app/providers/providers.dart';
// import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:chat/common.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;
import 'package:chat/app/modules/message/controllers/message_controller.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatController extends GetxController {
  types.User? _user;
  types.User? get user => _user;
  late String _roomId;
  String get roomId => _roomId;

  @override
  void onInit() {
    if (ChatProvider.to.currentAccount != null) {
      _user = types.User(id: ChatProvider.to.currentAccount!.userAtDomain);
    }
    final pageArguments = Get.arguments;
    if (pageArguments["id"] != null && pageArguments["id"] is String) {
      _roomId = pageArguments["id"];
    }
    final messageController = MessageController.to;

    messageController.setCurrentRoomId(_roomId);

    super.onInit();
  }

  @override
  void onReady() async {
    final messageController = MessageController.to;
    final room = messageController.getCurrentRoom()!;
    if (!room.isInitMessages) {
      try {
        await MessageController.to.initRoomMessage(_roomId);
        update();
      } catch (e) {
        print(e);
      }
    }

    super.onReady();
  }

  Future<void> handleSendPressed(types.PartialText message) async {
    final messageController = MessageController.to;
    messageController.sendMessage(_roomId, message.text);
  }
}
