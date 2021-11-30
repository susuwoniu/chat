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
    bool isLoading = false,
    bool isInitMessages = false,
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
      createdAt: message.createdAt.millisecondsSinceEpoch,
      id: message.id,
      text: message.text,
    );
  }

  // 房间的id列表，按照更新时间倒序
  final RxList<String> indexes = RxList<String>();
  final RxMap<String, Room> entities = RxMap<String, Room>({});
  final RxMap<String, types.Message> messageEntities =
      RxMap<String, types.Message>({});
  // 房间里的信息id列表，按照创建时间倒序
  final RxMap<String, List<String>> roomMessageIndexesMap =
      RxMap<String, List<String>>({});
  final _currentRoomId = "".obs;
  String get currentRoomId => _currentRoomId.value;

  @override
  Future<void> onReady() async {
    await init();
    super.onReady();
  }

  Future<void> init() async {
    if (ChatProvider.to.roomManager != null &&
        ChatProvider.to.isOpened == false) {
      ChatProvider.to.roomManager!.roomMessageUpdated.listen((event) {
        updateRoomMessage(event);
      });
      final rooms = await ChatProvider.to.roomManager!.getAllRooms();
      for (var room in rooms) {
        entities[room.id] = Room.fromXmppRoom(room);
        roomMessageIndexesMap[room.id] = [];
        // duduplicate
        if (!indexes.contains(room.id)) {
          indexes.add(room.id);
        }
      }
    }
  }

  Future<void> sendMessage(String roomId, String text) async {
    final roomManager = ChatProvider.to.roomManager!;
    roomManager.sendMessage(roomId, text);
  }

  /// 获取历史聊天记录
  Future<void> initRoomMessage(String roomId) async {
    final roomManager = ChatProvider.to.roomManager!;
    final room = entities[roomId];

    if (room != null) {
      room.isLoading = true;
      entities[roomId] = room;
      final currentRoomMessageIndexes = roomMessageIndexesMap[roomId] ?? [];
      final currentLastMessageId = currentRoomMessageIndexes.isNotEmpty
          ? currentRoomMessageIndexes.last
          : null;
      try {
        final messages = await roomManager.getMessages(
          roomId,
        );
        room.isLoading = false;
        room.isInitMessages = true;
        entities[roomId] = room;

        if (messages.isEmpty) {
          return;
        }
        Map<String, types.Message> newEntities = {};
        List<String> newIndexes = [];
        for (var i = 0; i < messages.length; i++) {
          final message = messages[i];
          newEntities[message.id] = formatMessage(message);
          newIndexes.insert(0, message.id);
        }
        messageEntities.addAll(newEntities);
        currentRoomMessageIndexes.addAll(newIndexes);
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
      entities.update(roomId, (value) {
        value.unreadCount = 0;
        return value;
      });
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
    final roomId = event.id;
    final message = event.data;
    final messageId = event.data.id;
    final preview = getPreview(message);
    messageEntities[messageId] = formatMessage(message);
    // 如果room message indexes不存在，则初始化
    if (roomMessageIndexesMap[roomId] == null) {
      roomMessageIndexesMap[roomId] = [];
    }
    // 如果room 不存在，则初始化
    if (entities[roomId] == null) {
      entities[roomId] = Room(roomId,
          name: roomId,
          preview: preview,
          unreadCount: 0,
          updatedAt: message.createdAt);
      indexes.insert(0, roomId);
    }
    final room = entities[roomId]!;
    final roomMessageIndexes = roomMessageIndexesMap[event.id]!;

    // 是否重复，重复就不更新这里

    if (roomMessageIndexes.contains(messageId)) {
      return;
    }
    // room对象是否需要更新
    var roomChanged = false;
    // 理论上这里监听到的一定是新消息，所以直接添加到数组的最前面
    roomMessageIndexesMap.update(roomId, (value) {
      value.insert(0, messageId);
      room.preview = getPreview(message);
      room.updatedAt = message.createdAt;
      return value;
    });

    // 房间是否被初始化过，也就是拉取过最新的50条信息
    // 为什么-1，roomMessageIndexes是没添加最后一条信息前的数组，所以-1
    if (!room.isInitMessages &&
        roomMessageIndexes.length >= ROOM_INIT_MESSAGE_COUNT - 1) {
      room.isInitMessages = true;
      roomChanged = true;
    }

    // 是否添加unread Count
    if (roomId != currentRoomId) {
      // 添加unreadCount
      room.unreadCount++;
      roomChanged = true;
    }

    if (roomChanged) {
      entities.update(roomId, (_) {
        return room;
      });
    }
  }

  void updateRoomPreview(xmpp.Event<xmpp.Message> event) {
    entities[event.id]!.preview = getPreview(event.data);
    entities[event.id]!.updatedAt = event.data.createdAt;

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
    markRoomAsRead(roomId);
    await Get.toNamed(Routes.CHAT, arguments: {
      'id': roomId,
    });
    setCurrentRoomId(null);
  }
}
