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
  // 客户端未读数，由于客户端的未读/已读状态是本地的，服务端未必及时同步，所以这里单独设置一个客户端的维度数，用于在客户端显示，优化用户体验，
  // unreadCount为服务端未读数量，应尽量保持及时把客户端的未读数量同步到服务端，但注意频率，不要无谓的发送
  int clientUnreadCount = 0;
  static fromXmppRoom(xmpp.Room xmppRoom) {
    final newRoom = Room(xmppRoom.id,
        name: xmppRoom.name,
        updatedAt: xmppRoom.updatedAt,
        preview: xmppRoom.preview,
        unreadCount: xmppRoom.unreadCount,
        clientUnreadCount: xmppRoom.unreadCount);
    return newRoom;
  }

  Room(
    String id, {
    required DateTime updatedAt,
    required String name,
    required String preview,
    required int unreadCount,
    this.clientUnreadCount = 0,
    this.isLoading = false,
    this.isInitClientMessages = false,
    this.isInitServerMessages = false,
  }) : super(id,
            updatedAt: updatedAt,
            name: name,
            preview: preview,
            unreadCount: unreadCount);
}

class MessageController extends GetxController {
  static MessageController get to => Get.find();
  static types.Message formatMessage(xmpp.Message message) {
    // todo 不支持的消息类型
    return types.TextMessage(
      author: types.User(id: message.from.userAtDomain),
      createdAt: message.createdAt.millisecondsSinceEpoch,
      id: message.id,
      text: message.text.isNotEmpty ? message.text : "not support message",
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
      if (room.clientUnreadCount > 0) {
        // only改变才改变
        entities.update(roomId, (value) {
          value.clientUnreadCount = 0;
          return value;
        });
      }

      // mark server room read
      // 保护 xx秒发一次
      // 只要服务端的unreadCount >0 才需要发送请求
      if (room.unreadCount > 0) {
        ChatProvider.to.roomManager!.markAsRead(roomId).catchError((e) {
          print("markas read error, $e");
        }).then((e) {
          // 成功才修改服务端的未读数量
          room.unreadCount = 0;
        });
      }
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
      room.clientUnreadCount++;
      roomChanged = true;
    }
    // 服务端未读数量，如果是对方发送的信息，每次都应该+1
    if (message.fromId != ChatProvider.to.currentAccount!.userAtDomain) {
      room.unreadCount++;
      if (roomId == currentRoomId) {
        // 设置服务器未读数量为0
        // TODO 是否需要节流，防止频繁请求
        markRoomAsRead(roomId);
      }

      // 服务端未读数量不影响客户端展示,所以不需要更新rx map
      // dart是引用类型，所以这里对room的改变就已经变了
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
      if (room.unreadCount > 0 || room.clientUnreadCount > 0) {
        markRoomAsRead(roomId);
      }
      // 进入活动态
      // 暂时不实现，因为需要先进行协商才行，不能不分青红皂白就给对方发一个自己的状态，暂时不重要，后续再优化
      // ChatProvider.to.roomManager!.setChatState(roomId, xmpp.ChatState.active);
      await Get.toNamed(Routes.CHAT, arguments: {
        'id': roomId,
      });

      // 再次设为已读
      if (room.unreadCount > 0 || room.clientUnreadCount > 0) {
        markRoomAsRead(roomId);
      }

      setCurrentRoomId(null);

      // 取消活动态
      // ChatProvider.to.roomManager!.setChatState(roomId, xmpp.ChatState.inactive);
    }
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
