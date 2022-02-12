import 'package:chat/types/account.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/utils/string.dart';

import 'dart:io';

@immutable
class ImageSlider extends StatelessWidget {
  final ImageEntity img;
  final double height;
  final double width;

  ImageSlider({
    required this.img,
    required this.height,
    required this.width,
  });

  late ImageProvider _image;

  @override
  Widget build(BuildContext context) {
    final isNet = isUrl(img.url);
    if (isNet) {
      _image = CachedNetworkImageProvider(img.url);
    } else {
      _image = FileImage(File(img.url));
    }
    return Container(
      child: Stack(
        children: <Widget>[
          Image(
            image: _image,
            fit: BoxFit.cover,
            height: height,
            width: width,
          ),
        ],
      ),
    );
  }
}
