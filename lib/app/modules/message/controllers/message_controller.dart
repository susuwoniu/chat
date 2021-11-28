import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:chat/app/providers/providers.dart';
// import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:chat/utils/date_util.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/common.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;
import 'package:chat/types/types.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Room extends xmpp.Room {
  bool isLoading = false;
  bool isInitMessages = false;
  static fromXmppRoom(xmpp.Room xmppRoom) {
    return Room(xmppRoom.id,
        name: xmppRoom.name,
        updatedAt: xmppRoom.updatedAt,
        preview: xmppRoom.preview,
        unreadCount: xmppRoom.unreadCount);
  }

  Room(
    String id, {
    required DateTime updatedAt,
    required String name,
    required String preview,
    required int unreadCount,
  }) : super(id,
            updatedAt: updatedAt,
            name: name,
            preview: preview,
            unreadCount: unreadCount);
}

class MessageController extends GetxController {
  static MessageController get to => Get.find();
  static types.Message formatMessage(xmpp.Message message) {
    return types.TextMessage(
      author: types.User(id: message.from.userAtDomain),
      createdAt: message.updatedAt.millisecondsSinceEpoch,
      id: message.messageId!,
      text: message.text,
    );
  }

  // var list = <ConversationInfo>[].obs;
  // var imLogic = Get.find<ImProvider>();
  final RxList<String> indexes = RxList<String>();
  final RxMap<String, Room> entities = RxMap<String, Room>({});
  final RxMap<String, types.Message> messageEntities =
      RxMap<String, types.Message>({});
  final RxMap<String, List<String>> roomMessageIndexesMap =
      RxMap<String, List<String>>({});
  final _currentRoomId = "".obs;
  String get currentRoomId => _currentRoomId.value;
  @override
  void onInit() {
    super.onInit();
    // imLogic.conversationAddedSubject.listen((newList) {
    //   // getAllConversationList();
    //   // list.addAll(newList);
    //   list.insertAll(0, newList);
    // });
    // imLogic.conversationChangedSubject.listen((newList) {
    //   list.assignAll(newList);
    // });
  }

  @override
  Future<void> onReady() async {
    // getAllConversationList();

    // if (ChatProvider.to.messageArchiveManager != null) {
    //   final startTime = DateTime.now().subtract(Duration(days: 7));
    //   ChatProvider.to.messageArchiveManager!.queryByTime(start: startTime);
    // }

    if (ChatProvider.to.roomManager != null) {
      await ChatProvider.to.roomManager!.initRooms();
      ChatProvider.to.roomManager!.entities.forEach((k, v) {
        entities[k] = Room.fromXmppRoom(v);
        roomMessageIndexesMap[k] = [];
      });
      for (var chatId in ChatProvider.to.roomManager!.indexes) {
        indexes.add(chatId);
      }

      ChatProvider.to.roomManager!.roomAddedStreamController.listen((event) {
        // print("event: $event");
        addRoom(event);
        // updateChat(event);
      });
      ChatProvider.to.roomManager!.roomLastMessageUpdatedStreamController
          .listen((event) {
        // update message
        final message = event.data;
        messageEntities[event.data.id] = types.TextMessage(
            id: message.id,
            text: message.text,
            author: types.User(id: message.fromId));

        // print("event: $event");
        updateRoomMessage(event);
        updateRoomPreview(event);
        // messageEntities[event.data.id] = event.message;
      });
      ChatProvider.to.roomManager!.roomUnreadCountUpdatedStreamController
          .listen((event) {
        // print("event: $event");
        if (event.id != currentRoomId) {
          updateRoomUnreadCount(event);
        }
      });
    }
    super.onReady();
  }

  /// 获取历史聊天记录
  Future<void> initRoomMessage(String roomId) async {
    final roomManager = ChatProvider.to.roomManager!;
    final room = entities[roomId];
    if (room != null) {
      room.isLoading = true;
      entities[roomId] = room;
      try {
        final messages = await roomManager.getMessages(roomId);
        room.isLoading = false;
        room.isInitMessages = true;
        Map<String, types.Message> newEntities = {};
        List<String> newIndexes = [];
        for (var i = 0; i < messages.length; i++) {
          final message = messages[i];
          newEntities[message.id] = formatMessage(message);
          newIndexes.add(message.id);
        }
        messageEntities.addAll(newEntities);
        final currentRoomMessageIndexes = roomMessageIndexesMap[roomId];
        currentRoomMessageIndexes!.addAll(newIndexes);
        roomMessageIndexesMap[roomId] = currentRoomMessageIndexes;
        entities[roomId] = room;
      } catch (e) {
        room.isLoading = false;
        entities[roomId] = room;
        UIUtils.showError(e);
      }
    }
  }

  void markRoomAsRead(String roomId) {
    var room = entities[roomId];
    if (room != null) {
      room.unreadCount = 0;
      entities.addAll({roomId: room});
      // entities[roomId] = Room(room.id,
      //     name: room.name,
      //     updatedAt: room.updatedAt,
      //     preview: room.preview,
      //     unreadCount: room.unreadCount);
    }
  }

  Room? getCurrentRoom() {
    if (currentRoomId.isNotEmpty) {
      return entities[currentRoomId]!;
    } else {
      return null;
    }
  }

  Room? getRoom(String roomId) {
    return entities[roomId];
  }

  void setCurrentRoomId(String? id) {
    _currentRoomId.value = id ?? "";
  }

  void addRoom(xmpp.Event<xmpp.Room> event) {
    entities[event.id] = Room.fromXmppRoom(event.data);
    if (indexes.contains(event.id)) {
      indexes.remove(event.id);
    }
    indexes.insert(0, event.id);
  }

  static String getPreview(xmpp.Message message) {
    return message.text;
  }

  void updateRoomMessage(xmpp.Event<xmpp.Message> event) {
    final roomMessageIndexes = roomMessageIndexesMap[event.id];
    roomMessageIndexes!.add(event.data.id);
    roomMessageIndexesMap[event.id] = roomMessageIndexes;
  }

  void updateRoomPreview(xmpp.Event<xmpp.Message> event) {
    entities[event.id]!.preview = getPreview(event.data);
    entities[event.id]!.updatedAt = event.data.updatedAt;

    sortRooms();
  }

  void updateRoomUnreadCount(xmpp.Event<int> event) {
    final room = entities[event.id]!;
    room.unreadCount = event.data + entities[event.id]!.unreadCount;
    entities[event.id] = room;
  }

  void sortRooms() {
    indexes.sort((a, b) {
      final aRoom = entities[a];
      final bRoom = entities[b];
      if (aRoom != null && bRoom != null) {
        return bRoom.updatedAt.compareTo(aRoom.updatedAt);
      }
      return 0;
    });
  }

  Future<void> toChat(int index) async {
    var roomId = indexes[index];
    // var room = entities[roomId];
    // if (room != null) {
    //   room.unreadCount = 0;
    //   room.preview = "你好";
    //   entities[roomId] = room;
    // }
    UIUtils.toast("test");
    markRoomAsRead(roomId);
    // await Get.toNamed(Routes.CHAT, arguments: {
    //   'id': roomId,
    // });
    // setCurrentRoomId(null);
  }
}
