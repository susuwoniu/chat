import 'package:chat/app/widgets/avatar.dart';
import 'package:flutter/material.dart';

class ViewersList extends StatelessWidget {
  final String? img;
  final String name;
  final String viewerId;
  final int likeCount;

  ViewersList({
    Key? key,
    this.img,
    required this.name,
    required this.viewerId,
    required this.likeCount,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Avatar(name: name, uri: img, size: 20),
              SizedBox(
                width: 10,
              ),
              Text(name),
              SizedBox(
                width: 5,
              ),
              Text("💗"),
              SizedBox(
                width: 5,
              ),
              Text(likeCount.toString()),
            ],
          )
        ],
      ),
    );
  }
}
