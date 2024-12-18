import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/test1_controller.dart';

import '../../old_room/controllers/room_controller.dart';
import '../../old_room/views/chat_message.dart';
import '../../old_room/views/room_app_bar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Test1View extends GetView<Test1Controller> {
  @override
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _blankNode = FocusNode();
  final _controller = RoomController.to;
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: roomAppBar(context, 'usename'),
      body: SafeArea(
        child: Container(
            child: Column(
              // MODIFIED
              children: [
                Flexible(
                    child: Obx(() => ScrollablePositionedList.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: _controller.indexes.length,
                          initialScrollIndex: _controller.indexes.isNotEmpty
                              ? _controller.indexes.length - 1
                              : 0,
                          itemBuilder: (context, index) {
                            final id = _controller.indexes[index];
                            final message = _controller.entities[id]!;
                            return ChatMessage(
                                text: message.text,
                                name: message.name,
                                isMe: message.isMe);
                          },
                          itemScrollController: _scrollController,
                        ))),
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
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  )
                : null),
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
      data: IconThemeData(),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Obx(() {
            final _isComposing = _controller.isComposing.value;
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
                      _controller.setIsComposing(text.trim().isNotEmpty);
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
                            child: Text('Send'.tr),
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
    _scrollController.scrollTo(
        index:
            _controller.indexes.isNotEmpty ? _controller.indexes.length - 1 : 0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic);
    _textController.clear();
    _controller.postMessage(text, "your name", true);
  }
}
