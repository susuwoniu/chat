import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, required this.name}); // MODIFIED
  final String text;
  final String name;
  // final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(name[0])),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.headline5),
                Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text,
                        style: Theme.of(context).textTheme.headline5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
