import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {required this.text, required this.name, required this.isMe}); // MODIFIED
  final String text;
  final String name;
  final bool isMe;
  // final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isMe
          ? EdgeInsets.fromLTRB(50, 0, 10, 0)
          : EdgeInsets.fromLTRB(10, 0, 50, 0),
      child: Row(
        textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: isMe
                ? const EdgeInsets.only(left: 12.0)
                : const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              child: Text(name[0]),
              radius: 22,
            ),
          ),
          Flexible(
              child: Container(
                  margin: EdgeInsets.only(top: 16.0),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            topRight: Radius.circular(18.0),
                            bottomLeft: Radius.circular(18.0),
                            bottomRight: Radius.circular(2.0),
                          )
                        : BorderRadius.circular(24),
                    color: isMe ? Colors.blue : Colors.white,
                  ),
                  child: Text(text,
                      style: (const TextStyle(
                        fontSize: 20,
                      ))))),
        ],
      ),
    );
  }
  // Widget _myMessageWidget(BuildContext context) {

  // }
}
