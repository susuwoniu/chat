import 'package:flutter/material.dart';

class AgeWidget extends StatelessWidget {
  final String text;
  final String iconName;

  AgeWidget({
    Key? key,
    required this.text,
    required this.iconName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        child: Row(children: [
          Text(iconName, style: TextStyle(fontSize: 22)),
          SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold))
        ]),
        decoration: BoxDecoration(
            color: Colors.white54, borderRadius: BorderRadius.circular(6)));
  }
}
