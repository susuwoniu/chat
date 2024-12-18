import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:chat/utils/string.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid
String randomString() {
  var random = Random.secure();
  var values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class RoomController extends GetxController {
  static RoomController get to => Get.find();

  late String roomId;

  final Rxn<types.TextMessage> _previewMessage = Rxn();
  types.TextMessage? get previewMessage => _previewMessage.value;
  StreamSubscription<RoomsState>? _roomsStateSubscription;

  @override
  void onInit() {
    final pageArguments = Get.arguments;
    if (pageArguments["id"] != null && pageArguments["id"] is String) {
      roomId = pageArguments["id"];
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

    if (messageController.entities[roomId] == null) {
      messageController.entities[roomId] = Room(
        roomId,
        updatedAt: DateTime.now(),
        room_info_id: jidToAccountId(roomId),
      );
    }
    messageController.setCurrentRoomId(roomId);
    initQuote();
  }

  initQuote() {
    var quote = Get.arguments["quote"];
    var reduce = Get.arguments["reduce"] ?? "true";

    if (quote != null && ChatProvider.to.currentChatAccount.value != null) {
      if (reduce == 'true' && quote.length > 144) {
        quote = quote.take(144).join();
        quote += "...";
      }
      var backgroundColor = Get.arguments["quote_background_color"];
      if (backgroundColor is String) {
        backgroundColor = int.parse(backgroundColor);
      }
      // todo check new line
      Map<String, dynamic> metadata = {};
      if (backgroundColor != null) {
        metadata["background_color"] = backgroundColor as int;
      }
      _previewMessage.value = types.TextMessage(
          metadata: metadata,
          text: toMarkdownQuote(quote),
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
    if (messageController.entities[roomId]!.isLoading == true) {
      return;
    }
    final room = messageController.getCurrentRoom();
    if (room != null && !room.isInitDbMessages) {
      try {
        messageController.entities[roomId]!.isLoading = true;

        await MessageController.to.getRoomEarlierMessage(roomId);

        messageController.entities[roomId]!.isLoading = false;
      } catch (e) {
        messageController.entities[roomId]!.isLoading = false;

        print(e);
      }
    }
    messageController.markRoomAsRead(roomId);
  }

  @override
  void onReady() async {
    // clear all notifications
    try {
      PushProvider.to.jpush.clearAllNotifications();
    } catch (e) {
      print("clear notifications error: $e");
    }
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
    await messageController.getRoomEarlierMessage(roomId);
  }

  void handleCancelPreview() {
    _previewMessage.value = null;
  }

  Future<void> handleSendPressed(types.PartialText message) async {
    final messageController = MessageController.to;
    // check is has preview message
    try {
      if (_previewMessage.value != null) {
        final quoteText = _previewMessage.value!.text;
        _previewMessage.value = null;

        messageController.sendTextMessage(
            roomId, types.PartialText(text: quoteText + "\n\n" + message.text));
        super.update();
      } else {
        messageController.sendTextMessage(roomId, message);
      }
    } catch (e) {
      rethrow;
    }
  }
}
