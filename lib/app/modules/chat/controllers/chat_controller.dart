import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:convert';
import 'dart:math';
import 'package:chat/app/providers/providers.dart';
// import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:chat/common.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatController extends GetxController {
  // static types.Message formatMessage(Message message) {
  //   if (message.contentType == MessageType.text) {
  //     return types.TextMessage(
  //       author: types.User(id: message.sendID!),
  //       createdAt: (message.sendTime! / 1000000).floor(),
  //       id: message.clientMsgID!,
  //       text: message.seq.toString() + ". " + message.content!,
  //     );
  //   } else {
  //     return types.UnsupportedMessage(
  //         id: message.clientMsgID!, author: types.User(id: message.sendID!));
  //   }
  // }

  final _indexes = RxList<String>([]);
  RxList<String> get indexes => _indexes;
  final isLoading = true.obs;
  final currentEndCursor = ''.obs;
  final isDataEmpty = false.obs;
  types.User? _user;
  types.User? get user => _user;
  late String _chatId;
  late String _chatType;
  final _entities = RxMap<String, types.Message>({});
  RxMap<String, types.Message> get entities => _entities;
  final count = 0.obs;
  // bool isCurrentChat(Message message) {
  //   var senderId = message.sendID;
  //   var groupId = message.groupID;
  //   var sessionType = message.sessionType;
  //   var isCurSingleChat =
  //       sessionType == 1 && _chatType == PRIVATE_CHAT && senderId == _chatId;
  //   var isCurGroupChat =
  //       sessionType == 2 && _chatType == GROUP_CHAT && _chatId == groupId;
  //   return isCurSingleChat || isCurGroupChat;
  // }

  @override
  void onInit() {
    // if (AuthProvider.to.accountId != null) {
    //   _user = types.User(id: AuthProvider.to.accountId!);
    // }
    // final pageArguments = Get.arguments;
    // if (pageArguments["id"] != null && pageArguments["id"] is String) {
    //   _chatId = pageArguments["id"];
    // }
    // _chatType = pageArguments["type"] ?? PRIVATE_CHAT;

    // ImProvider.to.onRecvNewMessage = (Message message) {
    //   // 如果是当前窗口的消息
    //   if (isCurrentChat(message)) {
    //     // 对方正在输入消息
    //     if (message.contentType == MessageType.typing) {
    //       // todo
    //     } else {
    //       // messageList.insert(0, message);
    //       _entities[message.clientMsgID!] = formatMessage(message);
    //       _indexes.add(message.clientMsgID!);
    //     }
    //   }
    // };
    super.onInit();
  }

  @override
  void onReady() async {
    // try {
    //   await getHistoryMessages();
    // } catch (e) {
    //   print(e);
    // }
    super.onReady();
  }

  // /// 获取历史聊天记录
  // Future<void> getHistoryMessages() async {
  //   final messages =
  //       await OpenIM.iMManager.messageManager.getHistoryMessageList(
  //     userID: _chatType == PRIVATE_CHAT ? _chatId : null,
  //     groupID: _chatType == GROUP_CHAT ? _chatId : null,
  //     count: 100,
  //   );
  //   Map<String, types.Message> newEntities = {};
  //   List<String> newIndexes = [];
  //   for (var i = 0; i < messages.length; i++) {
  //     final message = messages[i];
  //     newEntities[message.clientMsgID!] = formatMessage(message);
  //     newIndexes.add(message.clientMsgID!);
  //   }

  //   entities.addAll(newEntities);
  //   indexes.addAll(newIndexes);
  // }

  // Future<void> handleSendPressed(types.PartialText message) async {
  //   final openMessage = await OpenIM.iMManager.messageManager.createTextMessage(
  //     text: message.text,
  //   );
  //   final textMessage = types.TextMessage(
  //     author: _user!,
  //     createdAt: DateTime.now().millisecondsSinceEpoch,
  //     id: openMessage.clientMsgID!,
  //     text: message.text,
  //   );

  //   _entities[textMessage.id] = textMessage;
  //   _indexes.add(textMessage.id);

  //   // _addMessage(textMessage);
  //   // entities[textMessage.id!] = textMessage;
  //   await OpenIM.iMManager.messageManager.sendMessage(
  //     message: openMessage,
  //     userID: _chatId,
  //     groupID: null,
  //   );
  // }

  @override
  void onClose() {}
  void increment() => count.value++;
}
