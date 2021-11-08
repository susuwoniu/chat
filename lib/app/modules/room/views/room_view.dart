import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../controllers/room_controller.dart';
import 'package:flutter/foundation.dart';
import 'chat_message.dart';

class RoomView extends GetView<RoomController> {
  const RoomView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatScreen();
  }
}

class ChatScreen extends StatelessWidget {
  // MODIFIED
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _blankNode = FocusNode();
  final controller = RoomController.to;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // _focusNode.requestFocus();

    return Scaffold(
      appBar: mybar(context, 'usename'),
      body: Container(
          child: Column(
            // MODIFIED
            children: [
              Flexible(
                  child: Obx(
                () => ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(8.0),
                  reverse: false,
                  itemBuilder: (_, int index) {
                    final id = controller.indexes[index];
                    final message = controller.entities[id]!;
                    return ChatMessage(
                        text: message.text,
                        name: message.name,
                        isMe: message.isMe);
                  },
                  itemCount: controller.indexes.length,
                ),
              )),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(context),
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

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
      data: IconThemeData(),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Obx(() {
            final _isComposing = controller.isComposing.value;
            return Row(
              children: [
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 8,
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 1.5,
                    ),
                    controller: _textController,
                    onChanged: (String text) {
                      controller.setIsComposing(text.trim().isNotEmpty);
                    },
                    onSubmitted:
                        _isComposing ? _handleSubmitted : null, // MODIFIED
                    decoration: InputDecoration(hintText: 'Send a message'),

                    focusNode: _focusNode,
                  ),
                ),
                Container(
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? // MODIFIED
                        TextButton(
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
            );
          })),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    controller.postMessage(text, "your name", true);
    _scrollToEnd();
  }

  void _scrollToEnd() {
    final offset = _scrollController.position.maxScrollExtent + 50;
    _scrollController.animateTo(offset,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
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
