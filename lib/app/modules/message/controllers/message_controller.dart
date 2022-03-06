import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/common.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;
import '../../main/controllers/bottom_navigation_bar_controller.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:file_picker/file_picker.dart';
import '../../home/controllers/home_controller.dart';
import 'package:chat/utils/string.dart';

class Room extends xmpp.Room {
  bool isLoading = false;
  bool isLoadingServerMessage = false;
  bool isLoadingDbMessage = false;
  bool isInitClientMessages = false;
  bool isInitDbMessages = false;
  bool isLastPage = false;
  final String? room_info_id;
  // 客户端未读数，由于客户端的未读/已读状态是本地的，服务端未必及时同步，所以这里单独设置一个客户端的维度数，用于在客户端显示，优化用户体验，
  // unreadCount为服务端未读数量，应尽量保持及时把客户端的未读数量同步到服务端，但注意频率，不要无谓的发送
  int clientUnreadCount = 0;
  static fromXmppRoom(xmpp.Room xmppRoom) {
    final newRoom = Room(xmppRoom.id,
        room_info_id: jidToAccountId(xmppRoom.id),
        updatedAt: xmppRoom.updatedAt,
        preview: xmppRoom.preview,
        unreadCount: xmppRoom.unreadCount,
        clientUnreadCount: xmppRoom.unreadCount);
    return newRoom;
  }

  Room(
    String id, {
    required DateTime updatedAt,
    String preview = "",
    String? resource,
    int unreadCount = 0,
    required this.room_info_id,
    this.clientUnreadCount = 0,
    this.isLoading = false,
    this.isInitClientMessages = false,
    this.isInitDbMessages = false,
  }) : super(id,
            updatedAt: updatedAt,
            resource: resource,
            preview: preview,
            unreadCount: unreadCount);
}

class MessageController extends GetxController {
  String? chatAccountId;

  static MessageController get to => Get.find();
  static types.Message formatMessage(xmpp.Message message) {
    // todo 不支持的消息类型
    // is images
    types.Status? status;
    switch (message.status) {
      case xmpp.MessageStatus.sending:
        status = types.Status.sending;
        break;
      case xmpp.MessageStatus.sent:
        status = types.Status.sent;
        break;
      case xmpp.MessageStatus.delivered:
        status = types.Status.delivered;
        break;
      case xmpp.MessageStatus.seen:
        status = types.Status.seen;
        break;
      case xmpp.MessageStatus.error:
        status = types.Status.error;
        break;
      default:
        status = types.Status.sending;
        break;
    }
    if (message.images != null && message.images!.isNotEmpty) {
      return types.ImageMessage(
          author: types.User(id: message.from.userAtDomain),
          createdAt: message.createdAt.millisecondsSinceEpoch,
          id: message.id,
          uri: message.images![0].uri,
          name: message.images![0].name,
          status: status,
          height: message.images![0].height,
          width: message.images![0].width,
          size: message.images![0].size);
    } else if (message.files != null && message.files!.isNotEmpty) {
      return types.FileMessage(
          author: types.User(id: message.from.userAtDomain),
          createdAt: message.createdAt.millisecondsSinceEpoch,
          id: message.id,
          uri: message.files![0].uri,
          name: message.files![0].name,
          status: status,
          size: message.files![0].size);
    }

    return types.TextMessage(
      author: types.User(id: message.from.userAtDomain),
      createdAt: message.createdAt.millisecondsSinceEpoch,
      id: message.id,
      status: status,
      text: message.text.isNotEmpty ? message.text : "empty message",
    );
  }

  final _isInitRooms = false.obs;
  bool get isInitRooms => _isInitRooms.value;
  final _isLoadingRooms = false.obs;
  bool get isLoadingRooms => _isLoadingRooms.value;
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
  //  db id 信息,内部使用，不用obs到界面
  final Map<String, List<int>> roomDbMessageIndexesMap = {};

  final _currentRoomId = RxnString();
  String? get currentRoomId => _currentRoomId.value;
  StreamSubscription<xmpp.Event<String, xmpp.Message>>?
      _roomMessageUpdatedSubscription;

  Stream<RoomsState> get roomsStateStream => _roomsStateStreamController.stream;
  final StreamController<RoomsState> _roomsStateStreamController =
      StreamController.broadcast();
  @override
  void onInit() {
    ever<xmpp.ConnectionState>(ChatProvider.to.rawConnectionState, (event) {
      if (event == xmpp.ConnectionState.connected ||
          event == xmpp.ConnectionState.disconnected) {
        // 初始化房间列表
        init().catchError((e) {
          print(e);
          UIUtils.showError(e);
        });
      }
    });

    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  Future<void> init() async {
    if (ChatProvider.to.roomManager != null) {
      if (_roomMessageUpdatedSubscription != null) {
        _roomMessageUpdatedSubscription!.cancel();
      }
      _roomMessageUpdatedSubscription =
          ChatProvider.to.roomManager!.roomMessageUpdated.listen((event) async {
        await updateRoomMessage(event);
      });

      await initRooms();
    }
  }

  void setIsLoading(bool value) {
    _isLoadingRooms.value = value;
  }

  Future<List<Room>?> initRooms() async {
    if (ChatProvider.to.roomManager != null &&
        _isInitRooms.value == false &&
        isLoadingRooms == false) {
      _isLoadingRooms.value = true;
      try {
        // first try to load cache
        var totalUnreadCount = 0;
        final rooms = await ChatProvider.to.roomManager!.getAllRooms();
        // get room name, avatar
        for (var room in rooms) {
          entities[room.id] = Room.fromXmppRoom(room);
          if (roomMessageIndexesMap[room.id] == null) {
            roomMessageIndexesMap[room.id] = [];
          }
          // duduplicate
          if (!indexes.contains(room.id)) {
            indexes.add(room.id);
          }
          totalUnreadCount += entities[room.id]!.clientUnreadCount;
        }

        _isLoadingRooms.value = false;
        _isInitRooms.value = true;
        _roomsStateStreamController.add(RoomsState.inited);
        BottomNavigationBarController.to
            .setMessageNotificationCount(totalUnreadCount);
        return rooms.map<Room>((room) => Room.fromXmppRoom(room)).toList();
      } catch (e) {
        _isLoadingRooms.value = false;
        _isInitRooms.value = true;

        _roomsStateStreamController.add(RoomsState.error);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> fetchAccounts(List<String> jids) async {
    if (jids.isNotEmpty) {
      // TODO check cache
      final result = await getRawAccountsByIds(jids
          .where((jid) => jidToAccountId(jid) != null)
          .map((jid) => jidToAccountId(jid)!)
          .toList());
      // save account
      final Map<String, SimpleAccountEntity> accountMap = {
        for (var v in result)
          v["id"]: SimpleAccountEntity.fromJson(v["attributes"])
      };
      await AuthProvider.to.saveSimpleAccounts(accountMap);
      // todo save to auth provider
    }
  }

  Future<List<dynamic>> getRawAccountsByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return [];
    }
    final result =
        await APIProvider.to.get('/account/accounts', query: {"ids": ids});
    return List<dynamic>.from(result["data"] as List);
  }

  Future<void> tryToInitRoom(String roomId, xmpp.Message? message,
      {String? resource}) async {
    // check room inbo exists

    chatAccountId = jidToAccountId(roomId);
    final theAccount = chatAccountId != null
        ? AuthProvider.to.simpleAccountMap[chatAccountId]
        : null;
    if (chatAccountId != null && theAccount == null) {
      try {
        await HomeController.to
            .getOtherAccount(id: chatAccountId!, persist: true);
      } catch (e) {
        UIUtils.showError(e);
      }
    } else if (chatAccountId != null && theAccount != null) {
      // psersist account
      if (SimpleAccountMapCacheProvider.to.getObject(chatAccountId!) == null) {
        final simpleAccountMap = <String, SimpleAccountEntity>{};
        simpleAccountMap[chatAccountId!] = theAccount;
        SimpleAccountMapCacheProvider.to.addAll(simpleAccountMap);
      }
    }
    if (entities[roomId] == null) {
      entities[roomId] = Room(
        roomId,
        resource: resource ?? message?.room.resource,
        unreadCount: 0,
        updatedAt: message != null ? message.createdAt : DateTime.now(),
        room_info_id: jidToAccountId(roomId),
        preview: message != null ? getPreview(message) : "",
      );
    }
    // add index
    if (!indexes.contains(roomId)) {
      indexes.insert(0, roomId);
    }
    if (roomMessageIndexesMap[roomId] == null) {
      roomMessageIndexesMap[roomId] = [];
    }
  }

  Future<void> sendTextMessage(
      String roomId, types.PartialText _message) async {
    final roomManager = ChatProvider.to.roomManager!;
    final room = entities[roomId]!;
    final message = roomManager.createTextMessage(
      roomId,
      _message.text,
      resource: room.resource,
    );
    await updateRoomMessage(xmpp.Event(
      roomId,
      message,
    ));
    try {
      await roomManager.sendMessage(roomId, message);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendMessage(String roomId, types.Message rawMessage) async {
    var message = messageEntities[rawMessage.id];

    if (message != null) {
      message = message.copyWith(status: types.Status.sending);

      messageEntities[rawMessage.id] = message;
      final roomManager = ChatProvider.to.roomManager!;

      try {
        await roomManager.resendMessage(rawMessage.id);
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> sendFileMessage(String roomId, FilePickerResult result) async {
    var mimeType = mime(result.files.single.path!);
    final roomManager = ChatProvider.to.roomManager!;

    // create message
    final message = roomManager.createFileMessage(
      roomId,
      size: result.files.single.size,
      fileName: result.files.single.name,
      filePath: result.files.single.path!,
      mimeType: mimeType!,
    );
    await updateRoomMessage(xmpp.Event(roomId, message));

    await roomManager.sendFileMessage(roomId, message);
  }

  Future<void> sendImageMessage(String roomId, XFile result) async {
    var mimeType = result.mimeType;
    if (result.mimeType == null) {
      mimeType = mime(result.path);
    }
    // TODO 判断图片类型
    final roomManager = ChatProvider.to.roomManager!;
    final bytes = await result.readAsBytes();
    final image = await decodeImageFromList(bytes);

    // create message
    final message = roomManager.createImageMessage(roomId,
        size: bytes.length,
        fileName: result.name,
        filePath: result.path,
        mimeType: mimeType!,
        height: image.height.toDouble(),
        width: image.width.toDouble());
    await updateRoomMessage(xmpp.Event(roomId, message));

    await roomManager.sendFileMessage(
      roomId,
      message,
      getThumbnail: (file) {
        final thumbnailUri = '${file.uri}/thumbnail';
        print("thumbnailUri: $thumbnailUri");
        return xmpp.MessageThumbnail(
          uri: thumbnailUri,
          mimeType: mimeType!,
          height: image.height.toDouble() * 300 / image.width.toDouble(),
          width: 300,
        );
      },
    );
  }

  handlePreviewDataFetched(String messageId, types.PreviewData previewData) {
    var message = messageEntities[messageId];
    if (message != null) {
      message = message.copyWith(previewData: previewData);
      messageEntities[messageId] = message;
    }
  }

  // 获取更早的服务器archive信息
  Future<void> getRoomEarlierMessage(String roomId) async {
    final roomManager = ChatProvider.to.roomManager!;
    final room = entities[roomId];

    if (room != null) {
      if (room.isLoadingDbMessage) {
        return;
      }
      room.isLoadingDbMessage = true;

      if (!room.isInitClientMessages) {
        room.isLoading = true;
      }
      entities[roomId] = room;
      final currentRoomMessageIndexes = roomMessageIndexesMap[roomId] ?? [];
      final currentRoomServerMessageIndexes =
          roomServerMessageIndexesMap[roomId] ?? [];
      final currentRoomDbMessageIndexes = roomDbMessageIndexesMap[roomId] ?? [];
      final _currentEarliestServerMessageId =
          currentRoomServerMessageIndexes.isNotEmpty
              ? currentRoomServerMessageIndexes.last
              : null;
      final currentEarliestDbMessageId = currentRoomDbMessageIndexes.isNotEmpty
          ? currentRoomDbMessageIndexes.last
          : null;
      try {
        final limit = 8;
        final messages = await roomManager.getMessages(
            roomId: roomId, beforeId: currentEarliestDbMessageId);
        if (messages.length < limit) {
          room.isLastPage = true;
        }
        Map<String, types.Message> newEntities = {};
        List<String> newIndexes = [];
        List<String> newServerIndexes = [];
        List<int> newDbIndexes = [];

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
          if (message.dbId != null) {
            if (!currentRoomDbMessageIndexes.contains(message.dbId!)) {
              newDbIndexes.insert(0, message.dbId!);
            }
          }
        }
        messageEntities.addAll(newEntities);
        currentRoomMessageIndexes.addAll(newIndexes);
        roomMessageIndexesMap[roomId] = currentRoomMessageIndexes;
        currentRoomServerMessageIndexes.addAll(newServerIndexes);
        roomServerMessageIndexesMap[roomId] = currentRoomServerMessageIndexes;
        currentRoomDbMessageIndexes.addAll(newDbIndexes);
        roomDbMessageIndexesMap[roomId] = currentRoomDbMessageIndexes;
        room.isLoadingDbMessage = false;
        room.isLoading = false;
        room.isInitClientMessages = true;
        room.isInitDbMessages = true;
        entities[roomId] = room;
      } catch (e) {
        room.isLoadingDbMessage = false;
        room.isLoading = false;
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
        updateTotalUnreadCount();
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
    if (currentRoomId != null) {
      return entities[currentRoomId]!;
    } else {
      return null;
    }
  }

  Room? getRoom(String roomId) {
    return entities[roomId];
  }

  void setCurrentRoomId(String? id) {
    if (id != null && entities[id] != null) {
      _currentRoomId.value = id;
    } else {
      _currentRoomId.value = null;
    }
  }

  static String getPreview(xmpp.Message message) {
    return message.text;
  }

  void updateMessageStatusAsDelivered(String messageId) {
    var message = messageEntities[messageId];
    if (message != null) {
      message = message.copyWith(status: types.Status.sent);
      messageEntities[messageId] = message;
    }
  }

  Future<void> updateRoomMessage(xmpp.Event<String, xmpp.Message> event) async {
    final roomFullJid = event.id;
    final message = event.data;
    final messageId = event.data.id;
    final preview = getPreview(message);
    messageEntities[messageId] = formatMessage(message);
    final roomId = xmpp.Jid.fromFullJid(roomFullJid).userAtDomain;
    await tryToInitRoom(roomFullJid, message);
    final room = entities[roomId]!;
    final roomMessageIndexes = roomMessageIndexesMap[event.id]!;

    // 是否重复，重复就不更新这里

    if (roomMessageIndexes.contains(messageId)) {
      return;
    }
    // room对象是否需要更新
    var roomChanged = true;
    room.preview = preview;
    room.updatedAt = message.createdAt;
    // 理论上这里监听到的一定是新消息，所以直接添加到数组的最前面
    roomMessageIndexesMap.update(roomId, (value) {
      value.insert(0, messageId);
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
      updateTotalUnreadCount();
    }
    sortRooms();
  }

  void updateTotalUnreadCount() {
    // 计算total unread count
    var totalUnreadCount = 0;
    for (var roomId in indexes) {
      final theRoom = entities[roomId];
      if (theRoom != null && theRoom.clientUnreadCount > 0) {
        totalUnreadCount += theRoom.clientUnreadCount;
      }
    }
    BottomNavigationBarController.to
        .setMessageNotificationCount(totalUnreadCount);
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

  Future<void> toRoom(int index) async {
    final roomId = indexes[index];
    Get.toNamed(Routes.ROOM, arguments: {
      'id': roomId,
    });
  }

  @override
  void onClose() {
    dipose();
    super.onClose();
  }

  void cancelSubscription() {
    if (_roomMessageUpdatedSubscription != null) {
      _roomMessageUpdatedSubscription!.cancel();
    }

    _roomsStateStreamController.close();
  }

  void onDismiss(int index) {
    final roomId = indexes[index];
    // delete message
    // ToDo
    roomMessageIndexesMap.remove(roomId);
    indexes.removeAt(index);

    //
    ChatProvider.to.roomManager?.markAsArchive(roomId);

    // clear database, and clear delete server
  }

  void dipose() {
    cancelSubscription();
    // 清空房间
    indexes.clear();
  }
}

String? jidToAccountId(String jid) {
  final jidPrefix = jid.split("@")[0];
  if (jidPrefix.isNotEmpty) {
    final accountId = jidPrefix;
    if (isValidId(accountId)) {
      return accountId;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

String jidToName(String jid) {
  final jidPrefix = jid.split("@")[0];
  return jidPrefix;
}

enum RoomsState { inited, error }
