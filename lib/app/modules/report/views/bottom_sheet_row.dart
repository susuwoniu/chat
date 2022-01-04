import 'package:flutter/material.dart';

class BottomSheetRow extends StatelessWidget {
  final String text;
  final Function onPressed;

  BottomSheetRow({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          onPressed();
        },
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            text,
            style: TextStyle(fontSize: 17, color: Colors.blue),
          ),
        ));
  }
}
