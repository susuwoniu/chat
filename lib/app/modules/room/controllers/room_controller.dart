import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';
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

  types.TextMessage? _previewMessage;
  types.TextMessage? get previewMessage => _previewMessage;
  StreamSubscription<RoomsState>? _roomsStateSubscription;

  @override
  void onInit() {
    final pageArguments = Get.arguments;
    if (pageArguments["id"] != null && pageArguments["id"] is String) {
      _roomId = pageArguments["id"];
    }
    init();

    final messageController = MessageController.to;

    _roomsStateSubscription =
        messageController.roomsStateStream.listen((event) {
      if (event == RoomsState.inited) {
        initQuote();
        initRoom().then((rooms) {}).catchError((error) {
          print(error);
        });
      } else if (event == RoomsState.error) {
        Get.back();
      }
    });

    super.onInit();
  }

  void init() {
    final messageController = MessageController.to;
    // is room exists

    if (messageController.entities[_roomId] == null) {
      messageController.entities[_roomId] = Room(
        _roomId,
        updatedAt: DateTime.now(),
        room_info_id: jidToAccountId(_roomId),
      );
    }
    messageController.setCurrentRoomId(_roomId);
    initQuote();
  }

  initQuote() {
    final quote = Get.arguments["quote"];
    if (quote != null && ChatProvider.to.currentChatAccount.value != null) {
      _previewMessage = types.TextMessage(
          text: "> $quote",
          author: ChatProvider.to.currentChatAccount.value!,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: "preview");
    }
  }

  Future<void> initRoom() async {
    final messageController = MessageController.to;
    if (!messageController.isInitRooms) {
      return;
    }
    if (messageController.entities[_roomId]!.isLoading == true) {
      return;
    }
    messageController.entities[_roomId]!.isLoading = true;
    final room = messageController.getCurrentRoom();
    if (room != null && !room.isInitServerMessages) {
      try {
        await MessageController.to.getRoomServerEarlierMessage(_roomId);
        messageController.markRoomAsRead(_roomId);

        messageController.entities[_roomId]!.isLoading = false;
      } catch (e) {
        messageController.entities[_roomId]!.isLoading = false;

        print(e);
      }
    }
  }

  @override
  void onReady() async {
    await initRoom();
    super.onReady();
  }

  void dipose() {
    if (_roomsStateSubscription != null) {
      _roomsStateSubscription!.cancel();
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
