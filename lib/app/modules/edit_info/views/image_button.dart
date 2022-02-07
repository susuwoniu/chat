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
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: Theme.of(context).dividerColor,
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 2), // changes position of shadow
              )
            ]),
            child: CircleWidget(
              icon: Icon(isAdd ? Icons.add_rounded : Icons.close_rounded),
              backgroundColor: isAdd
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimary,
              iconColor: isAdd
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
              height: 32,
              iconSize: 23,
              onPressed: onPressed,
            )));
  }
}
