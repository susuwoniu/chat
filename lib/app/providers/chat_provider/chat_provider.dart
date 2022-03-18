import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;
import 'package:get/get.dart';
import 'dart:async';
import 'package:chat/common.dart';
import '../auth_provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chat/app/common/get_device_id.dart';
import '../push_provider.dart';

class ChatProvider extends GetxService {
  static ChatProvider get to => Get.find();
  // final _isLoading = true.obs;
  // final _isConnected = false.obs;
  final currentChatAccount = Rxn<types.User>();
  // bool get isConnected => _isConnected.value;
  // bool get isLoading => _isLoading.value;
  final rawConnectionState =
      Rx<xmpp.ConnectionState>(xmpp.ConnectionState.connecting);
  xmpp.ConnectionState get connectionState => rawConnectionState.value;
  String connectionStateMessage = "";
  bool _isInitingConnection = false;
  xmpp.DbProvider? get database => _connection?.db;
  xmpp.Connection? _connection;
  xmpp.Jid? _currentAccount;
  xmpp.Jid? get currentAccount => _currentAccount;
  xmpp.RoomManager? _roomManager;
  xmpp.RoomManager? get roomManager => _roomManager;
  xmpp.StreamManagementModule? streamManager;
  late StreamSubscription<AuthStatus> _authStatusSubscription;
  StreamSubscription<xmpp.Event<xmpp.ConnectionState, String>>?
      _connectionStateSubscription;

  bool get isOpened {
    if (_connection != null) {
      return _connection!.isOpened();
    } else {
      return false;
    }
  }

  @override
  void onInit() async {
    // init im login
    _authStatusSubscription = AuthProvider.to.authUpdated.listen((event) async {
      if (event == AuthStatus.loginSuccess) {
        await connect();
      } else if (event == AuthStatus.logoutSuccess) {
        dipose();
      }
    });
    // init xmpp client

    super.onInit();
  }

  Future<void> reconnect() async {
    if (_connection != null) {
      _connection!.reconnect();
    }
  }

  Future<void> clearAllNotifications() async {
    if (_connection != null) {
      _connection!.reconnect();
    }
  }

  void closeConnection() {
    if (_connection != null) {
      _connection!.close();
      // _connection!.handleCloseState();
      // _connection!.closeSocket();
    }
  }

  Future<void> connect() async {
    // init im login
    if (AuthProvider.to.isLogin) {
      // disable current
      dipose();
      try {
        // get device id
        final deviceId = await getDeviceId();
        await ChatProvider.to.login(
            AuthProvider.to.accountId!,
            AppConfig().config.imDomain,
            AuthProvider.to.imAccessToken!,
            deviceId ?? "flutter");
      } catch (e) {
        print(e);
        rethrow;
      }
    }
  }

  Future<void> logout() async {
    // get jpush id
    // final id = await PushProvider.to.jpush.getRegistrationID();
    // final _pushManager = xmpp.PushManager.getInstance(_connection!);
    // await _pushManager.disablePush(deviceId: id);
  }

  dipose() {
    if (_connectionStateSubscription != null) {
      _connectionStateSubscription!.cancel();
    }

    _connection?.dispose();
    _connection = null;
    _currentAccount = null;
    _roomManager = null;
  }

  @override
  onClose() {
    _authStatusSubscription.cancel();
    super.onClose();
  }

  Future<void> login(
      String accountId, String domain, String token, String device) async {
    // String? resourceId = await PlatformDeviceId.getDeviceId;
    // final resource = resourceId
    // final platform = Platform.isAndroid ? 'Android' : 'iOS';
    if (_isInitingConnection) {
      return;
    }
    _isInitingConnection = true;
    final jid = "$accountId@$domain/$device";
    final account = xmpp.XmppAccountSettings.fromJid(jid, token);
    account.reconnectionTimeout = 3000;
    rawConnectionState.value = xmpp.ConnectionState.connecting;
    if (_connection == null) {
      _connection = xmpp.Connection(account);
      // roomManager
      _currentAccount = _connection!.fullJid;
      currentChatAccount(types.User(id: _currentAccount!.userAtDomain));
      _roomManager = xmpp.RoomManager.getInstance(_connection!);
      if (AppConfig.to.isDev) {
        print("isDev: ${AppConfig.to.isDev}");
        xmpp.Log.logXmpp = true;
        xmpp.Log.logLevel = xmpp.LogLevel.DEBUG;
      } else {
        print("isProd");
        // TODO
        xmpp.Log.logXmpp = true;
        xmpp.Log.logLevel = xmpp.LogLevel.DEBUG;
      }

      try {
        await _connection!.init();
      } catch (e) {
        _isInitingConnection = false;
        rethrow;
      }
      _connectionStateSubscription =
          _roomManager!.connectionUpdated.listen((event) {
        // if connected, then register push
        if (event.id == xmpp.ConnectionState.connected) {
          // get jpush id
          PushProvider.to.jpush.getRegistrationID().then((id) {
            final _pushManager = xmpp.PushManager.getInstance(_connection!);
            final push_service = GetPlatform.isIOS ? 'apns' : 'fcm';
            _pushManager.initPush(
                service: push_service,
                deviceId: id,
                mode: AppConfig.to.isDev ? 'dev' : 'prod');
          });
        }

        rawConnectionState.value = event.id;
      });
      _connection!.connect();
    } else {
      _connection!.reconnect();
    }
    _isInitingConnection = false;
  }
}
