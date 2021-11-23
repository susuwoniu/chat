import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class MessagesStream implements xmpp.MessagesListener {
  @override
  void onNewMessage(xmpp.MessageStanza? message) {
    if (message!.body != null) {
      print('New message: ${message.body}');
    }
  }
}
