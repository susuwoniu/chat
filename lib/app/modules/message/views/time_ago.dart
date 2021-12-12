import 'package:flutter/material.dart';
import 'package:chat/app/ui_utils/time.dart';

class TimeAgo extends StatelessWidget {
  final DateTime updatedAt;

  TimeAgo({
    Key? key,
    required this.updatedAt,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final time = getTime(updatedAt);
    return Text(time,
        style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor));
  }
}
