import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class BlankImage extends StatelessWidget {
  final String? page;
  final void Function() onPressed;

  BlankImage({
    Key? key,
    this.page,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.fromLTRB(2, 0, 22, 15),
          height: 146,
          width: 110,
          child: DottedBorder(
            strokeWidth: 4,
            child: page != null
                ? Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.camera_alt_outlined,
                        color: Theme.of(context).hintColor, size: 32),
                  )
                : Text(''),
            color: Theme.of(context).dividerColor,
            radius: Radius.circular(8),
            dashPattern: [6, 6],
            borderType: BorderType.RRect,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
        ));
  }
}
