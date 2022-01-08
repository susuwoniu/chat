import 'package:flutter/material.dart';

class AppbarBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      decoration: BoxDecoration(color: Colors.grey.shade400, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(1, 2), // changes position of shadow
        )
      ]),
    );
  }
}
