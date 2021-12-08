import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;
import 'package:get/get.dart';
import 'dart:async';
import 'package:chat/common.dart';
import 'package:chat/errors/errors.dart';
import '../auth_provider.dart';
import 'package:chat/config/config.dart';

class ChatProvider extends GetxService {
  static ChatProvider get to => Get.find();
  final _isLoading = true.obs;
  final _isConnected = false.obs;
  bool get isConnected => _isConnected.value;
  bool get isLoading => _isLoading.value;
  xmpp.Connection? _connection;
  xmpp.Jid? _currentAccount;
  xmpp.Jid? get currentAccount => _currentAccount;
  xmpp.RoomManager? _roomManager;
  xmpp.RoomManager? get roomManager => _roomManager;
  xmpp.StreamManagementModule? streamManager;
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
        dipose();
      }
    });

    super.onInit();
  }

  Future<void> connect() async {
    // init im login
    if (AuthProvider.to.isLogin) {
      // disable current
      dipose();
      final username = "im${AuthProvider.to.accountId}";
      try {
        await ChatProvider.to.login(username, AppConfig().config.imDomain,
            AuthProvider.to.imAccessToken!, "flutter");
      } catch (e) {
        print(e);
        rethrow;
      }
    }
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
    _authStatusSubscription?.cancel();
    super.onClose();
  }

  Future<void> login(
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

    xmpp.Log.logXmpp = false; // todo

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
    _isConnected.value = false;
    if (!completer.isCompleted) {
      completer.completeError(exception);
    }
    if ((_connection != null &&
            _connection!.state == xmpp.XmppConnectionState.ForcefullyClosed) ||
        _connection == null) {
      _isLoading.value = false;
      _connectionUpdatedStreamController.add(ConnectionState.disconnected);
    } else {
      _isLoading.value = true;
      _connectionUpdatedStreamController.add(ConnectionState.connecting);
    }
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
        streamManager = _connection!.streamManagementModule;
        _isLoading.value = false;
        if (!completer.isCompleted) {
          completer.complete();
        }
        _isConnected.value = true;
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
