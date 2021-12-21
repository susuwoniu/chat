import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class BlankImage extends StatelessWidget {
  BlankImage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _imgWidth = _width * 0.27;
    final _margin = _width * 0.03;

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, _margin, _margin * 1.1),
      height: _width * 0.37,
      width: _imgWidth,
      child: DottedBorder(
        strokeWidth: 4,
        child: Text(''),
        color: Colors.white,
        radius: Radius.circular(8),
        dashPattern: [6, 6],
        borderType: BorderType.RRect,
      ),
      decoration: BoxDecoration(
        color: Color(0xffe4e6ec),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
