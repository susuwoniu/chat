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
        color: Colors.grey.shade700,
        size: 20,
      ),
      Text(
        text,
        textAlign: TextAlign.start,
        style:
            TextStyle(height: 1.4, fontSize: 18, color: Colors.grey.shade700),
      ),
      // SizedBox(height: 30),
    ]);
  }
}
