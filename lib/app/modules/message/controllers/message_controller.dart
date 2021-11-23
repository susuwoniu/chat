import 'package:get/get.dart';
import 'dart:convert';
import 'package:chat/app/providers/providers.dart';
// import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:chat/utils/date_util.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/common.dart';

class MessageController extends GetxController {
  // var list = <ConversationInfo>[].obs;
  // var imLogic = Get.find<ImProvider>();
  var list = [].obs;
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
  void onReady() {
    // getAllConversationList();

    if (ChatProvider.to.messageArchiveManager != null) {
      final startTime = DateTime.now().subtract(Duration(days: 7));
      ChatProvider.to.messageArchiveManager!.queryByTime(start: startTime);
    }

    // if (ChatProvider.to.chatManager != null) {
    //   ChatProvider.to.chatManager!.chatListStream.listen((event) {
    //     print("event: $event");
    //   });
    // }
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void toChat(int index) async {
    // var info = list.elementAt(index);
    // var draftText = await AppNavigator.startChat(
    //     uid: info.userID,
    //     gid: info.groupID,
    //     name: info.showName,
    //     icon: info.faceUrl,
    //     draftText: info.draftText);

    // markMessageHasRead(index);
    // Get.toNamed(Routes.CHAT, arguments: {
    //   'id': info.userID != null && info.userID!.isNotEmpty
    //       ? info.userID
    //       : info.groupID,
    //   'type': info.userID != null && info.userID!.isNotEmpty
    //       ? PRIVATE_CHAT
    //       : GROUP_CHAT,
    //   'title': info.showName,
    //   'avatar': info.faceUrl
    // });

    // print('draftText:$draftText');
    // setConversationDraft(
    //   cid: info.conversationID,
    //   draftText: draftText,
    // );
  }

  /// 获取会话
  // void getAllConversationList() {
  //   OpenIM.iMManager.conversationManager
  //       .getAllConversationList()
  //       .then((value) => list
  //         ..clear()
  //         ..addAll(value))
  //       .catchError((e) => print(e));
  // }

  // /// 标记会话已读
  // void markMessageHasRead(int index) {
  //   var info = list.elementAt(index);
  //   if (info.userID != null && info.userID.isBlank == false) {
  //     OpenIM.iMManager.conversationManager.markSingleMessageHasRead(
  //       userID: info.userID!,
  //     );
  //   } else {
  //     OpenIM.iMManager.conversationManager.markGroupMessageHasRead(
  //       groupID: info.groupID!,
  //     );
  //   }
  // }

  // /// 置顶会话
  // void pinConversation(int index) {
  //   var info = list.elementAt(index);
  //   OpenIM.iMManager.conversationManager.pinConversation(
  //     conversationID: info.conversationID,
  //     isPinned: !(info.isPinned == 1),
  //   );
  // }

  // /// 删除会话
  // void deleteConversation(int index) {
  //   var info = list.elementAt(index);
  //   OpenIM.iMManager.conversationManager.deleteConversation(
  //     conversationID: info.conversationID,
  //   );
  // }

  // /// 设置草稿
  // void setConversationDraft({required String cid, required String draftText}) {
  //   OpenIM.iMManager.conversationManager.setConversationDraft(
  //     conversationID: cid,
  //     draftText: draftText,
  //   );
  // }

  // /// 解析草稿
  // String? getPrefixText(int index) {
  //   var info = list.elementAt(index);
  //   String? prefix;
  //   if (null != info.draftText && '' != info.draftText) {
  //     var map = json.decode(info.draftText!);
  //     String text = map['text'];
  //     if (text.isNotEmpty) {
  //       prefix = '[draft text]';
  //     }
  //   } else if (info.latestMsg?.contentType == MessageType.at_text) {
  //     try {
  //       Map map = json.decode(info.latestMsg!.content!);
  //       String text = map['text'];
  //       // bool isAtSelf = map['isAtSelf'];
  //       bool isAtSelf = text.contains('@${OpenIM.iMManager.uid} ');
  //       if (isAtSelf == true) {
  //         prefix = '[@you}]';
  //       }
  //     } catch (e) {}
  //   }
  //   return prefix;
  // }

  // Map<String, String> getAtUserMap(int index) {
  //   var info = list.elementAt(index);
  //   // if (info.isGroupChat) {
  //   //   Map<String, String> map =
  //   //       DataPersistence.getAtUserMap(info.groupID!)?.cast() ?? {};
  //   //   return map;
  //   // }
  //   return {};
  // }

  // /// 解析消息内容
  // String getMsgContent(int index) {
  //   var info = list.elementAt(index);
  //   if (null != info.draftText && '' != info.draftText) {
  //     var map = json.decode(info.draftText!);
  //     String text = map['text'];
  //     if (text.isNotEmpty) {
  //       // Map<String, dynamic> atMap = map['at'];
  //       // print('text:$text  atMap:$atMap');
  //       // atMap.forEach((uid, uname) {
  //       //   text = text.replaceAll(uid, uname);
  //       // });
  //       return text;
  //     }
  //   }
  //   if (info.latestMsg?.contentType == MessageType.picture) {
  //     return '[picture]';
  //   } else if (info.latestMsg?.contentType == MessageType.video) {
  //     return '[video]';
  //   } else if (info.latestMsg?.contentType == MessageType.voice) {
  //     return '[void]';
  //   } else if (info.latestMsg?.contentType == MessageType.file) {
  //     return '[file]';
  //   } else if (info.latestMsg?.contentType == MessageType.location) {
  //     return '[location]';
  //   } else if (info.latestMsg?.contentType == MessageType.merger) {
  //     return '[record]';
  //   } else if (info.latestMsg?.contentType == MessageType.card) {
  //     return '[card]';
  //   } else if (info.latestMsg?.contentType == MessageType.revoke) {
  //     if (info.latestMsg?.sendID == OpenIM.iMManager.uid) {
  //       return '[you recall message]';
  //     } else {
  //       return '"[${info.latestMsg!.senderNickName}"recall]';
  //     }
  //   } else if (info.latestMsg?.contentType == MessageType.at_text) {
  //     String text = info.latestMsg!.content!;
  //     try {
  //       Map map = json.decode(text);
  //       text = map['text'];
  //       // text = text.replaceAll('@${OpenIM.iMManager.uid} ', '');
  //       return text;
  //     } catch (e) {}
  //     return text;
  //   } else if (info.latestMsg?.contentType == MessageType.quote) {
  //     return info.latestMsg?.quoteElem?.text ?? "";
  //   } else if (info.latestMsg?.contentType == MessageType.text) {
  //     return info.latestMsg?.content?.trim() ?? '';
  //   } else {
  //     var text;
  //     try {
  //       var content = json.decode(info.latestMsg!.content!);
  //       text = content['defaultTips'];
  //     } catch (e) {
  //       text = json.encode(info.latestMsg);
  //     }
  //     return text;
  //   }
  // }

  // // String text = info.latestMsg?.content?.trim() ?? '';
  // // if (text.contains("\"defaultTips\":")) {
  // //   try {
  // //     Map map = json.decode(text);
  // //     return map['defaultTips'];
  // //   } catch (e) {}
  // // }

  // /// 头像
  // String? getAvatar(int index) {
  //   var info = list.elementAt(index);
  //   return info.faceUrl;
  // }

  // bool isGroupChat(int index) {
  //   var info = list.elementAt(index);
  //   return info.isGroupChat;
  // }

  // /// 显示名
  // String getShowName(int index) {
  //   var info = list.elementAt(index);
  //   if (info.showName == null || info.showName.isBlank!) {
  //     return info.userID!;
  //   }
  //   return info.showName!;
  // }

  // /// 时间
  // String getTime(int index) {
  //   var info = list.elementAt(index);
  //   return DateUtil.getChatTime(info.latestMsgSendTime!);
  // }

  // /// 未读数
  // int getUnreadCount(int index) {
  //   var info = list.elementAt(index);
  //   return info.unreadCount ?? 0;
  // }

  // bool existUnreadMsg(int index) {
  //   return getUnreadCount(index) > 0;
  // }

  // /// 判断置顶
  // bool isPinned(int index) {
  //   var info = list.elementAt(index);
  //   return info.isPinned == 1;
  // }

  // void toAddFriend() {
  //   // AppNavigator.startAddFriend();
  //   // Get.toNamed(AppRoutes.ADD_FRIEND);
  // }

  // void createGroup() {
  //   // AppNavigator.startSelectContacts(
  //   //   action: SelAction.CRATE_GROUP,
  //   //   defaultCheckedUidList: [OpenIM.iMManager.uid],
  //   // );
  // }

  // void toScanQrcode() {
  //   // AppNavigator.startScanQrcode();
  // }

  // void toViewCallRecords() {
  //   // AppNavigator.startCallRecords();
  // }
}
