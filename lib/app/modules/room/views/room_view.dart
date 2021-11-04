import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../controllers/room_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

class RoomView extends GetView<RoomController> {
  const RoomView({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChatScreen();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {required this.text, required this.animationController}); // MODIFIED
  final String text;
  String _name = 'Your Name';
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: Theme.of(context).textTheme.headline5),
                  Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text(text,
                          style: Theme.of(context).textTheme.headline5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // MODIFIED
  final _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mybar(context, 'usename'),
      body: Container(
          child: Column(
            // MODIFIED
            children: [
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                )
              : null),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: _isComposing ? _handleSubmitted : null, // MODIFIED
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
                focusNode: _focusNode,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? // MODIFIED
                    CupertinoButton(
                        child: Text('Send'),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _isComposing // MODIFIED
                            ? () => _handleSubmitted(
                                _textController.text) // MODIFIED
                            : null, // MODIFIED
                      ))
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    setState(() {
      _messages.insert(0, message);
      _focusNode.requestFocus();
      message.animationController.forward();
    });
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  AppBar mybar(BuildContext context, String st) {
    return AppBar(
        centerTitle: true,
        leadingWidth: 30,
        title: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 5),
            child: Flex(direction: Axis.horizontal, children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () async {},
                      child: CircleAvatar(radius: 22),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(st),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        child: Text("💗",
                            style: Theme.of(context).textTheme.headline6),
                        onPressed: () {},
                      ))),
            ])));
  }
}
