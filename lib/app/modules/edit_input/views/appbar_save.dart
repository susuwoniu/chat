import 'package:flutter/material.dart';

class AppBarSave extends StatelessWidget {
  final bool isActived;
  final Function onPressed;

  AppBarSave({
    Key? key,
    required this.isActived,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return TextButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Container(
          child: Text("save",
              style: TextStyle(
                  fontSize: 16,
                  color: isActived ? Colors.white : Colors.black38)),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(right: _width * 0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isActived ? Colors.blue : Colors.black12,
          ),
        ));
  }
}
