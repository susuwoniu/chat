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
        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 2), // changes position of shadow
          )
        ]),
        child: CircleWidget(
          icon: Icon(isAdd ? Icons.add_rounded : Icons.close_rounded),
          backgroundColor:
              isAdd ? Colors.blue : Theme.of(context).colorScheme.onPrimary,
          iconColor:
              isAdd ? Theme.of(context).colorScheme.onPrimary : Colors.blue,
          height: 32,
          iconSize: 23,
          onPressed: onPressed,
        ));
  }
}
