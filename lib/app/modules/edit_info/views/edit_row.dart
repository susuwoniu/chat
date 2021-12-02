import 'package:flutter/material.dart';

class EditRow extends StatelessWidget {
  final String title;
  final String content;
  final void Function() onPressed;

  EditRow({
    Key? key,
    required this.title,
    required this.content,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            padding: EdgeInsets.fromLTRB(22, 0, 18, 15),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              verticalDirection: VerticalDirection.up,
              children: [
                Expanded(
                  flex: 8,
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          content,
                          style: TextStyle(fontSize: 17),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Icon(Icons.arrow_forward_ios_rounded, size: 20)),
              ],
            )));
  }
}
