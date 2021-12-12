import 'package:chat/app/widges/avatar.dart';
import 'package:flutter/material.dart';

class ViewersList extends StatelessWidget {
  final String? img;
  final String name;
  final String viewerId;

  ViewersList({
    Key? key,
    this.img,
    required this.name,
    required this.viewerId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [Avatar(name: name, uri: img), Text(name)],
          )
        ],
      ),
    );
  }
}
