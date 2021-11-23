import 'package:flutter/material.dart';

class ProfileText extends StatelessWidget {
  final String text;
  final IconData iconName;

  ProfileText({
    Key? key,
    required this.text,
    required this.iconName,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(
        iconName,
        color: Colors.grey,
        size: 25,
      ),
      Container(
        padding: EdgeInsets.fromLTRB(5, 0, 0, 2),
        child: Text(
          text,
          style: TextStyle(fontSize: 22, color: Colors.grey),
        ),
      ),
      SizedBox(height: 40),
    ]);
  }
}
