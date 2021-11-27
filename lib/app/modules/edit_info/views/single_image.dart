import 'package:flutter/material.dart';

class SingleImage extends StatelessWidget {
  final String img;

  SingleImage({
    Key? key,
    required this.img,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _imgWidth = _width * 0.27;
    final _margin = _width * 0.03;

    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, _margin, _margin * 1.1),
        child: Stack(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(img,
                  height: _width * 0.37, width: _imgWidth, fit: BoxFit.cover)),
        ]));
  }
}
