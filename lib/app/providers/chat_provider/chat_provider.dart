import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'dart:io';
import 'dart:async';
import 'package:chat/common.dart';
import 'package:chat/errors/errors.dart';
import '../auth_provider.dart';

class ChatProvider extends GetxService {
  static ChatProvider get to => Get.find();
  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  xmpp.Connection? _connection;
  xmpp.Jid? _currentAccount;
  xmpp.Jid? get currentAccount => _currentAccount;
  xmpp.RoomManager? _roomManager;
  xmpp.RoomManager? get roomManager => _roomManager;
  StreamSubscription<AuthStatus>? _authStatusSubscription;
  Stream<ConnectionState> get connectionUpdated =>
      _connectionUpdatedStreamController.stream;
  final StreamController<ConnectionState> _connectionUpdatedStreamController =
      StreamController.broadcast();
  StreamSubscription<xmpp.XmppConnectionState>? _connectionStateSubscription;
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
    _authStatusSubscription = AuthProvider.to.authUpdated.listen((event) {
      if (event == AuthStatus.loginSuccess) {
        connect().then((_) {
          _isLoading.value = false;
        }).catchError((e) {
          _isLoading.value = false;
        });
      } else if (event == AuthStatus.logoutSuccess) {
        onClose();
      }
    });

    super.onInit();
  }

  Future<void> connect() async {
    // init im login
    try {
      await ChatProvider.to.login(
          "user3",
          "xmpp.scuinfo.com",
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJ1c2VyMyIsIm5hbWUiOiJKb2huIERvZSIsImFkbWluIjp0cnVlLCJuYmYiOjE2Mzc2OTIzNDQsImlhdCI6MTYzNzY5MjM0NCwiZXhwIjoxNzk5Njk1OTQ0fQ.OvsgTeNtjMZCiwaJUDW5uorukHVVIhsieLg_e5X5HQ86VA7MH-On-s-y81VuBKJFiJ6JiDyBr9zbABnseCVJyuRfgBwAacZAqpqHrqGkGdLpz6h1GPEC7Myh4_f-cdhGuzssSD3d2fAVkbM6B5a7b5NQzCPr_e_dwqP1Pe2g_kcsw9iBu9kjqes5tDX7Fx5zDrcBPhOPoBQobLPUPtTVSm6K_IINFiLWhIZg9SVN9SgQFciEiY7y7b5m5laYgZaxEjWyU34vsr8QNCeMbWUd73B0-g7j_x3lQzd-YJXltnpVTNVEMYsmVC_jI7lCPlLt-ILwTvT-vG8SI_IrKzktLg",
          "flutter");
    } catch (e) {
      print(e);
    }
  }

  @override
  onClose() {
    if (_connectionStateSubscription != null) {
      _connectionStateSubscription!.cancel();
    }

    _connection?.dispose();
    _connection = null;
    _currentAccount = null;
    _roomManager = null;
    super.onClose();
  }

  Future login(
      String accountId, String domain, String token, String device) async {
    // String? resourceId = await PlatformDeviceId.getDeviceId;
    // final resource = resourceId
    // final platform = Platform.isAndroid ? 'Android' : 'iOS';
    final jid = "$accountId@$domain/$device";
    final account = xmpp.XmppAccountSettings.fromJid(jid, token);
    account.reconnectionTimeout = 3000;
    _isLoading.value = true;
    _connection = xmpp.Connection(account);

    Completer<void> completer = Completer();

    xmpp.Log.logXmpp = true; // todo

    if (_connectionStateSubscription != null) {
      _connectionStateSubscription!.cancel();
    }

    _connectionStateSubscription =
        _connection!.connectionStateStream.listen((state) {
      _onConnectionStateChangedInternal(state, completer);
    });

    if (_connection!.state == xmpp.XmppConnectionState.ForcefullyClosed) {
      _connection!.reconnect();
    } else {
      _connection!.connect();
    }
    return completer.future;
  }

  void _throwExceptiohn(Completer completer, ServiceException exception) {
    _isLoading.value = false;
    if (!completer.isCompleted) {
      completer.completeError(exception);
    }
    _connectionUpdatedStreamController.add(ConnectionState.disconnected);
  }

  void _onConnectionStateChangedInternal(
    xmpp.XmppConnectionState state,
    Completer<void> completer,
  ) {
    switch (state) {
      case xmpp.XmppConnectionState.StartTlsFailed:
        Log.debug("Chat connection StartTlsFailed");
        _throwExceptiohn(
            completer,
            ServiceException("Chat connection StartTlsFailed",
                code: "StartTlsFailed"));
        break;
      case xmpp.XmppConnectionState.AuthenticationNotSupported:
        Log.debug("Chat connection AuthenticationNotSupported");
        _throwExceptiohn(
            completer,
            ServiceException("Chat connection AuthenticationNotSupported",
                code: "AuthenticationNotSupported"));
        break;

      case xmpp.XmppConnectionState.AuthenticationFailure:
        Log.debug("Chat connection AuthenticationFailure");

        _throwExceptiohn(
            completer,
            ServiceException("Chat connection AuthenticationFailure",
                code: "AuthenticationFailure"));
        break;
      case xmpp.XmppConnectionState.ForcefullyClosed:
        Log.debug("Chat connection ForcefullyClosed");

        _throwExceptiohn(
            completer,
            ServiceException("Open connection error: ForcefullyClosed",
                code: "ForceClosed"));

        break;
      case xmpp.XmppConnectionState.Closed:
        Log.debug("Chat connection Closed");

        _throwExceptiohn(
            completer,
            ServiceException("Open connection Closed",
                code: "ConnectionClosed"));

        break;
      case xmpp.XmppConnectionState.Ready:
        Log.debug("Chat connection Ready");
        _currentAccount = _connection!.fullJid;
        _roomManager = xmpp.RoomManager.getInstance(_connection!);

        _isLoading.value = false;
        if (!completer.isCompleted) {
          completer.complete();
        }
        _connectionUpdatedStreamController.add(ConnectionState.connected);

        break;

      default:
    }
  }

  void logout() {
    if (_connection != null) {
      _connection!.close();
    }
  }
}

enum ConnectionState {
  connecting,
  connected,
  disconnected,
  error,
}
