import 'package:flutter/material.dart';

class OpenAvatar extends StatelessWidget {
  final String avatar;

  OpenAvatar({
    Key? key,
    required this.avatar,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.3),
          child: Image.network(avatar,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center)),
      Positioned(
          top: -100,
          left: 0,
          child: IconButton(
              icon: Icon(
                Icons.close_outlined,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }))
    ]);
  }
}
