import 'package:flutter/material.dart';

class MoreText extends StatelessWidget {
  final Function onPressed;

  MoreText({Key? key, required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
        child: TextButton(
          onPressed: () {
            onPressed();
          },
          child: Text(
            'More',
            style: TextStyle(fontSize: 18),
          ),
        ));
  }
}
