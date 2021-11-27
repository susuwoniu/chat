import 'package:flutter/material.dart';
import '../../me/views/circle_widget.dart';

class ImageButton extends StatelessWidget {
  final bool isAdd;
  final void Function() onPressed;

  ImageButton({
    Key? key,
    required this.isAdd,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: CircleWidget(
      icon: Icon(isAdd ? Icons.add_rounded : Icons.close_rounded),
      backgroundColor: Colors.white,
      iconColor: Colors.blue,
      height: 32,
      width: 32,
      onPressed: onPressed,
    ));
  }
}
