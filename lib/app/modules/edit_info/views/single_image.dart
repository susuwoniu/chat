import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chat/types/types.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/utils/string.dart';

class SingleImage extends StatelessWidget {
  final ImageEntity img;

  SingleImage({
    Key? key,
    required this.img,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _imgWidth = _width * 0.27;
    final _margin = _width * 0.03;
    final isNet = isUrl(img.url);
    ImageProvider _image;
    if (isNet) {
      _image = CachedNetworkImageProvider(img.url);
    } else {
      _image = FileImage(File(img.url));
    }
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, _margin, _margin * 1.1),
        child: Stack(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                  image: _image,
                  height: _width * 0.37,
                  width: _imgWidth,
                  fit: BoxFit.cover))
        ]));
  }
}
