import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final String? action;
  final String? text;

  final void Function() onPressed;

  NextButton({
    Key? key,
    this.action,
    required this.onPressed,
    this.text = 'next',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: _height * 0.07,
        width: _width * 0.95,
        margin: EdgeInsets.only(bottom: _height * 0.06),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        alignment: Alignment.center,
        child: Text(text!,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white)),
      ),
    );
  }
}
