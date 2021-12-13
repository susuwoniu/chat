import 'package:flutter/material.dart';

class AgeWidget extends StatelessWidget {
  final String text;
  final IconData icon;

  AgeWidget({Key? key, required this.text, required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Row(children: [
          Icon(
            icon,
            color: Colors.black54,
            size: 22,
          ),
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
