import 'package:flutter/material.dart';

class ProfileInfoText extends StatelessWidget {
  final String text;
  final IconData iconName;

  ProfileInfoText({
    Key? key,
    required this.text,
    required this.iconName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(
        iconName,
        color: Colors.grey,
        size: 25,
      ),
      Container(
        padding: EdgeInsets.fromLTRB(5, 4, 0, 4),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
      // SizedBox(height: 30),
    ]);
  }
}
