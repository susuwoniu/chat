import 'package:chat/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';

class RoomController extends GetxController {
  types.User? _user;
  types.User? get user => _user;
  late String _roomId;
  String get roomId => _roomId;
  String? _postId;
  String? get postId => _postId;
  types.TextMessage? _previewMessage;
  types.TextMessage? get previewMessage => _previewMessage;
  @override
  void onInit() {
    if (ChatProvider.to.currentAccount != null) {
      _user = types.User(id: ChatProvider.to.currentAccount!.userAtDomain);
    }
    final pageArguments = Get.arguments;
    if (pageArguments["id"] != null && pageArguments["id"] is String) {
      _roomId = pageArguments["id"];
    }
    if (pageArguments["post_id"] != null &&
        pageArguments["post_id"] is String) {
      _postId = pageArguments["post_id"];
    }
    final messageController = MessageController.to;

    messageController.setCurrentRoomId(_roomId);
    final homeController = HomeController.to;
    if (_postId != null &&
        homeController.postMap[_postId] != null &&
        _user != null) {
      _previewMessage = types.TextMessage(
          text: homeController.postMap[_postId]!.content,
          author: _user!,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: "preview");
    }
    super.onInit();
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

  @override
  void onClose() async {
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
    if (_previewMessage != null) {
      messageController.sendMessage(
          _roomId,
          types.PartialText(
            text: _previewMessage!.text,
          ));
      _previewMessage = null;
      messageController.sendMessage(_roomId, message);
    } else {
      messageController.sendMessage(_roomId, message);
    }
  }
}
