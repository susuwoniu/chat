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
  static types.Message formatMessage(xmpp.Message message) {
    if (message.text != null) {
      return types.TextMessage(
        author: types.User(id: message.from.userAtDomain),
        createdAt: message.updatedAt.millisecondsSinceEpoch,
        id: message.messageId!,
        text: message.text,
      );
    } else {
      return types.UnsupportedMessage(
          id: message.messageId!,
          author: types.User(id: message.from.userAtDomain));
    }
  }

  final isLoading = true.obs;
  final currentEndCursor = ''.obs;
  final isDataEmpty = false.obs;
  types.User? _user;
  types.User? get user => _user;
  late String _roomId;
  String get roomId => _roomId;
  late String _roomType;
  final count = 0.obs;
  // bool isCurrentChat(Message message) {
  //   var senderId = message.sendID;
  //   var groupId = message.groupID;
  //   var sessionType = message.sessionType;
  //   var isCurSingleChat =
  //       sessionType == 1 && _roomType == PRIVATE_CHAT && senderId == _roomId;
  //   var isCurGroupChat =
  //       sessionType == 2 && _roomType == GROUP_CHAT && _roomId == groupId;
  //   return isCurSingleChat || isCurGroupChat;
  // }

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
    // final roomManager = ChatProvider.to.roomManager!;
    // final room = roomManager.getChat(
    //   _roomId,
    // )!;
    // room.sendMessage(message.text);

    // addMessage(textMessage);

    // _addMessage(textMessage);
    // entities[textMessage.id!] = textMessage;
  }

  void increment() => count.value++;
}
