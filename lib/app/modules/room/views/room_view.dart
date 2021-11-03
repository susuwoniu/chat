import 'package:flutter/material.dart';

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
    return MaterialApp(
      home: ChatScreen(),
    );
  }

}
class ChatMessage extends StatelessWidget {
  ChatMessage(
      {required this.text, required this.animationController}); // MODIFIED
  final String text;
  String _name = 'Your Name';
  final AnimationController animationController; // NEW

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: // NEW
      CurvedAnimation(
          parent: animationController, curve: Curves.easeOut), // NEW
      axisAlignment: 0.0, // NEW
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
              // NEW
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: Theme.of(context).textTheme.headline4),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
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
  final List<ChatMessage> _messages = []; // NEW
  final FocusNode _focusNode = FocusNode(); // NEW
  bool _isComposing = false; // NEW

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
          child: Column(
            // MODIFIED
            children: [
              // NEW
              Flexible(
                // NEW
                child: ListView.builder(
                  // NEW
                  padding: EdgeInsets.all(8.0), // NEW
                  reverse: true, // NEW
                  itemBuilder: (_, int index) => _messages[index], // NEW
                  itemCount: _messages.length, // NEW
                ), // NEW
              ), // NEW
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS // NEW
              ? BoxDecoration(                                 // NEW
            border: Border(                              // NEW
              top: BorderSide(color: Colors.grey[200]!), // NEW
            ),                                           // NEW
          )                                              // NEW
              : null),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor), // NEW
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  // NEW
                  setState(() {
                    // NEW
                    _isComposing = text.isNotEmpty; // NEW
                  }); // NEW
                }, // NEW
                onSubmitted: _isComposing ? _handleSubmitted : null, // MODIFIED
                decoration:
                InputDecoration.collapsed(hintText: 'Send a message'),
                focusNode: _focusNode, // NEW
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: Theme.of(context).platform == TargetPlatform.iOS ? // MODIFIED
                CupertinoButton(                                          // NEW
                  child: Text('Send'),                                    // NEW
                  onPressed: _isComposing                                 // NEW
                      ? () =>  _handleSubmitted(_textController.text)     // NEW
                      : null,) :                                          // NEW
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isComposing // MODIFIED
                      ? () => _handleSubmitted(_textController.text) // MODIFIED
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
      // NEW
      _isComposing = false; // NEW
    }); // NEW

    ChatMessage message = ChatMessage(
      //NEW
      text: text,
      animationController: AnimationController(
        // NEW
        duration: const Duration(milliseconds: 300), // NEW
        vsync: this, // NEW
      ), // NEW
    ); //NEW
    //NEW
    setState(() {
      //NEW
      _messages.insert(0, message);
      _focusNode.requestFocus(); // NEW
      message.animationController.forward(); // NEW

//NEW
    });
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
