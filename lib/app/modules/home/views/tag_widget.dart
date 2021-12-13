import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final String text;
  final Function onPressed;

  TagWidget({Key? key, required this.text, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white38),
        child: GestureDetector(
          onTap: () {
            onPressed();
          },
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.tag_rounded, color: Colors.blueAccent),
            Text(text,
                style: (TextStyle(
                    fontSize: 20,
                    // fontStyle: FontStyle.italic,
                    // fontWeight: FontWeight.bold,
                    color: Colors.blueAccent))),
          ]),
        ));
  }
}
