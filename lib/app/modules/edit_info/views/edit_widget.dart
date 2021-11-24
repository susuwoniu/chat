import 'package:flutter/material.dart';

class EditWidget extends StatelessWidget {
  final String title;
  final String content;

  // final void Function() onPressed;

  EditWidget({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return Container(
        padding: EdgeInsets.fromLTRB(22, 12, 18, 12),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: Icon(Icons.arrow_forward_ios_rounded, size: 20)),
          ],
        ));
  }
}
