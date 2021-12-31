import 'package:flutter/material.dart';

class ReportType extends StatelessWidget {
  final String text;
  final Function onPressed;

  ReportType({
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
          width: 600,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
            ),
          )),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            text,
            style: TextStyle(fontSize: 17, color: Colors.blue),
          ),
        ));
  }
}
