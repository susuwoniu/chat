import 'dart:io';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import './im_callback.dart';
import 'package:path_provider/path_provider.dart';

class ImProvider extends GetxService with IMCallback {
  static ImProvider get to => Get.find();

  late Rx<UserInfo> userInfo;

  @override
  void onClose() {
    super.close();
    // OpenIM.iMManager.unInitSDK();
    super.onClose();
  }

  Future<void> init() async {
    // Initialize SDK
    await OpenIM.iMManager.initSDK(
      platform: Platform.isAndroid ? IMPlatform.android : IMPlatform.ios,
      ipApi: "https://im-api.scuinfo.com",
      ipWs: "wss://im-ws.scuinfo.com",
      dbPath: '${(await getApplicationDocumentsDirectory()).path}/',
      listener: OnInitSDKListener(
        onConnecting: () {},
        onConnectFailed: (code, error) {},
        onConnectSuccess: () {},
        onKickedOffline: () {},
        onUserSigExpired: () {},
        onSelfInfoUpdated: (u) {
          userInfo.value = u;
        },
      ),
    );
    OpenIM.iMManager.enabledSDKLog(enabled: true);
    // Set listener
    OpenIM.iMManager
      // Add message listener (remove when not in use)
      ..messageManager.addAdvancedMsgListener(OnAdvancedMsgListener(
        onRecvMessageRevoked: recvMessageRevoked,
        onRecvC2CReadReceipt: recvC2CReadReceipt,
        onRecvNewMessage: (Message message) {
          print("onRecvNewMessage");
        },
      ))

      // Set up message sending progress listener
      ..messageManager.setMsgSendProgressListener(OnMsgSendProgressListener(
        onProgress: progressCallback,
      ))

      // Set up friend relationship listener
      ..friendshipManager.setFriendshipListener(OnFriendshipListener(
        onBlackListAdd: blackListAdd,
        onBlackListDeleted: blackListDeleted,
        onFriendApplicationListAccept: friendApplicationListAccept,
        onFriendApplicationListAdded: friendApplicationListAdded,
        onFriendApplicationListDeleted: friendApplicationListDeleted,
        onFriendApplicationListReject: friendApplicationListReject,
        onFriendInfoChanged: friendInfoChanged,
        onFriendListAdded: friendListAdded,
        onFriendListDeleted: friendListDeleted,
      ))

      // Set up conversation listener
      ..conversationManager.setConversationListener(OnConversationListener(
        onConversationChanged: conversationChanged,
        onNewConversation: newConversation,
        onTotalUnreadMessageCountChanged: totalUnreadMsgCountChanged,
        // totalUnreadMsgCountChanged: (i) => unreadMsgCountCtrl.addSafely(i),
        onSyncServerFailed: () {},
        onSyncServerFinish: () {},
        onSyncServerStart: () {},
      ))

      // Set up group listener
      ..groupManager.setGroupListener(OnGroupListener(
        onApplicationProcessed: applicationProcessed,
        onGroupCreated: groupCreated,
        onGroupInfoChanged: groupInfoChanged,
        onMemberEnter: memberEnter,
        onMemberInvited: memberInvited,
        onMemberKicked: memberKicked,
        onMemberLeave: memberLeave,
        onReceiveJoinApplication: receiveJoinApplication,
      ));

    // ios no support
    if (Platform.isAndroid) {
      // sdk log set
      // OpenIM.iMManager.setSdkLog(enable: false);
    }

    initializedSubject.sink.add(true);
  }

  Future login(String uid, String token) async {
    var user = await OpenIM.iMManager.login(uid: uid, token: token);
    return userInfo = user.obs;
  }

  Future logout() {
    return OpenIM.iMManager.logout();
  }
}
