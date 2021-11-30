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
  bool isLoadingServerMessage = false;
  bool isInitClientMessages = false;
  bool isInitServerMessages = false;
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
    bool isInitClientMessages = false,
    bool isInitServerMessages = false,
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
  // 房间里已获取的服务器信息id列表，这里的信息应该比roomMessageIndexesMap中的少，因为只有主动获取的信息才会被放到这里
  // 分页获取服务器archive信息，只能依赖服务器id，所以必须在这维护一份时间倒序的，已获取的服务器信息id列表
  // 服务器id信息只用于内部使用，不用obs到界面
  final Map<String, List<String>> roomServerMessageIndexesMap = {};
  final _currentRoomId = "".obs;
  String get currentRoomId => _currentRoomId.value;
  StreamSubscription<ConnectionState>? _chatConnectionUpdatedSubscription;
  StreamSubscription<xmpp.Event<xmpp.Message>>? _roomMessageUpdatedSubscription;
  @override
  Future<void> onReady() async {
    _chatConnectionUpdatedSubscription =
        ChatProvider.to.connectionUpdated.listen((event) {
      if (event == ConnectionState.connected) {
        // 初始化房间列表
        init().catchError((e) {
          print(e);
          UIUtils.showError(e);
        });
      }
    });

    super.onReady();
  }

  Future<void> init() async {
    if (ChatProvider.to.roomManager != null) {
      _roomMessageUpdatedSubscription =
          ChatProvider.to.roomManager!.roomMessageUpdated.listen((event) {
        updateRoomMessage(event);
      });
      await initRooms();
    }
  }

  Future<List<Room>?> initRooms() async {
    if (ChatProvider.to.roomManager != null) {
      final rooms = await ChatProvider.to.roomManager!.getAllRooms();
      for (var room in rooms) {
        entities[room.id] = Room.fromXmppRoom(room);
        if (roomMessageIndexesMap[room.id] == null) {
          roomMessageIndexesMap[room.id] = [];
        }
        // duduplicate
        if (!indexes.contains(room.id)) {
          indexes.add(room.id);
        }
      }
      return rooms.map<Room>((room) => Room.fromXmppRoom(room)).toList();
    } else {
      return null;
    }
  }

  Future<void> sendMessage(String roomId, String text) async {
    final roomManager = ChatProvider.to.roomManager!;
    roomManager.sendMessage(roomId, text);
  }

  // 获取更早的服务器archive信息
  Future<void> getRoomServerEarlierMessage(String roomId) async {
    final roomManager = ChatProvider.to.roomManager!;
    final room = entities[roomId];

    if (room != null) {
      if (room.isLoadingServerMessage) {
        return;
      }
      room.isLoadingServerMessage = true;

      if (!room.isInitClientMessages) {
        room.isLoading = true;
      }
      entities[roomId] = room;
      final currentRoomMessageIndexes = roomMessageIndexesMap[roomId] ?? [];
      final currentRoomServerMessageIndexes =
          roomServerMessageIndexesMap[roomId] ?? [];

      final currentEarliestMessageId =
          currentRoomServerMessageIndexes.isNotEmpty
              ? currentRoomServerMessageIndexes.last
              : null;
      try {
        final messages = await roomManager.getMessages(roomId,
            beforeId: currentEarliestMessageId);
        room.isLoading = false;
        room.isLoadingServerMessage = false;
        if (currentEarliestMessageId == null) {
          room.isInitClientMessages = true;
          room.isInitServerMessages = true;
        }

        entities[roomId] = room;

        if (messages.isEmpty) {
          return;
        }
        Map<String, types.Message> newEntities = {};
        List<String> newIndexes = [];
        List<String> newServerIndexes = [];
        for (var i = 0; i < messages.length; i++) {
          final message = messages[i];
          newEntities[message.id] = formatMessage(message);
          // check if exist
          if (!currentRoomMessageIndexes.contains(message.id)) {
            newIndexes.insert(0, message.id);
          }
          if (message.serverId != null) {
            if (!currentRoomServerMessageIndexes.contains(message.serverId!)) {
              newServerIndexes.insert(0, message.serverId!);
            }
          }
        }
        messageEntities.addAll(newEntities);
        currentRoomMessageIndexes.addAll(newIndexes);
        roomMessageIndexesMap[roomId] = currentRoomMessageIndexes;
        currentRoomServerMessageIndexes.addAll(newServerIndexes);
        roomServerMessageIndexesMap[roomId] = currentRoomServerMessageIndexes;

        entities[roomId] = room;
      } catch (e) {
        room.isLoading = false;
        room.isLoadingServerMessage = false;
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
    // mark server room read
    // 保护 xx秒发一次
    // TODO
    ChatProvider.to.roomManager!.markAsRead(roomId).catchError((e) {
      print("markas read error, $e");
    });
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
    var roomChanged = true;
    // 理论上这里监听到的一定是新消息，所以直接添加到数组的最前面
    roomMessageIndexesMap.update(roomId, (value) {
      value.insert(0, messageId);
      room.preview = getPreview(message);
      room.updatedAt = message.createdAt;
      return value;
    });

    // 房间是否被初始化过，也就是拉取过最新的50条信息
    // 为什么-1，roomMessageIndexes是没添加最后一条信息前的数组，所以-1
    if (!room.isInitClientMessages &&
        roomMessageIndexes.length >= ROOM_INIT_MESSAGE_COUNT - 1) {
      room.isInitClientMessages = true;
      roomChanged = true;
    }

    // 是否添加unread Count
    if (roomId != currentRoomId &&
        message.fromId != ChatProvider.to.currentAccount!.userAtDomain) {
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
    final roomId = indexes[index];
    // 是否有未读消息，有的话，mark为已读
    final room = entities[roomId];
    if (room != null) {
      if (room.unreadCount > 0) {
        markRoomAsRead(roomId);
      }
    }
    // 进入活动态
    ChatProvider.to.roomManager!.setChatState(roomId, xmpp.ChatState.active);
    await Get.toNamed(Routes.CHAT, arguments: {
      'id': roomId,
    });
    ChatProvider.to.roomManager!.setChatState(roomId, xmpp.ChatState.inactive);
    setCurrentRoomId(null);
  }

  @override
  void onClose() {
    if (_chatConnectionUpdatedSubscription != null) {
      _chatConnectionUpdatedSubscription!.cancel();
    }
    if (_roomMessageUpdatedSubscription != null) {
      _roomMessageUpdatedSubscription!.cancel();
    }
    super.onClose();
  }
}
