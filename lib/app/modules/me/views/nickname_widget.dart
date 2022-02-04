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
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        child: Text(name,
            maxLines: 1,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
            )),
      ),
      SizedBox(width: 8),
      vip
          ? Icon(Icons.stars_rounded,
              color: Theme.of(context).primaryColor, size: 34)
          : SizedBox.shrink(),
    ]);
  }
}
