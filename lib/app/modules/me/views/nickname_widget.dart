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
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimary,
              overflow: TextOverflow.ellipsis,
            )),
      ),
      SizedBox(width: 6),
      vip
          ? Icon(Icons.stars_rounded,
              color: Theme.of(context).colorScheme.onSecondary, size: 32)
          : SizedBox.shrink(),
    ]);
  }
}
