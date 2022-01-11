import 'package:flutter/material.dart';

class ProfileInfoText extends StatelessWidget {
  final String text;
  final IconData icon;

  ProfileInfoText({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(
        icon,
        color: Colors.grey,
        size: 23,
      ),
      Container(
        padding: EdgeInsets.fromLTRB(5, 4, 0, 4),
        child: Text(
          text,
          style: TextStyle(fontSize: 19, color: Colors.grey),
        ),
      ),
      // SizedBox(height: 30),
    ]);
  }
}
