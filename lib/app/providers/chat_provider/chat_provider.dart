import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'dart:io';
import 'dart:async';
import 'package:chat/common.dart';
import 'package:chat/errors/errors.dart';
import './message_stream.dart';

class ChatProvider extends GetxService {
  static ChatProvider get to => Get.find();

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  xmpp.Connection? _connection;
  xmpp.ChatManager? _chatManager;
  xmpp.MessageArchiveManager? _messageArchiveManager;
  xmpp.ChatManager? get chatManager => _chatManager;
  xmpp.MessageArchiveManager? get messageArchiveManager =>
      _messageArchiveManager;
  StreamSubscription<xmpp.XmppConnectionState>? _connectionStateSubscription;
  bool isOpened() {
    if (_connection != null) {
      return _connection!.isOpened();
    } else {
      return false;
    }
  }

  dispose() {
    if (_connectionStateSubscription != null) {
      _connectionStateSubscription!.cancel();
    }
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
    _isLoading.value = false;
    if (!completer.isCompleted) {
      completer.completeError(exception);
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

        _chatManager = xmpp.ChatManager.getInstance(_connection!);
        _messageArchiveManager = _connection!.getMamModule();
        xmpp.MessagesListener messageStream = MessagesStream();

        final messageHandler = xmpp.MessageHandler.getInstance(_connection!);
        // var rosterManager = xmpp.RosterManager.getInstance(_connection!);
        messageHandler.messagesStream.listen(messageStream.onNewMessage);
        _isLoading.value = false;

        if (!completer.isCompleted) {
          completer.complete();
        }

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
