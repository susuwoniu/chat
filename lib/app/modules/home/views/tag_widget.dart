import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  TagWidget(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 14, bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.14),
        ),
        child: GestureDetector(
          onTap: () {
            onPressed();
          },
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.style, size: 18, color: color),
            SizedBox(width: 4),
            Flexible(
                child: Text(text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: (TextStyle(fontSize: 14, color: color)))),
            SizedBox(width: 10)
          ]),
        ));
  }
}
