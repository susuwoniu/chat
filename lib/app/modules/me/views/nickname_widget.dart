import 'package:flutter/material.dart';

class NicknameWidget extends StatelessWidget {
  final String name;
  final bool vip;

  NicknameWidget({
    Key? key,
    required this.name,
    required this.vip,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return Container(
        width: _width * 0.9,
        child: Expanded(
            child: Row(children: [
          Flexible(
            child: Text(name,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                )),
          ),
          vip
              ? Icon(Icons.stars_rounded, color: Colors.pink, size: 34)
              : SizedBox.shrink(),
        ])));
  }
}
