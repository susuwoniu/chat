import 'package:flutter/material.dart';

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

  getTime(DateTime time) {
    final _time = time.millisecondsSinceEpoch;
    final now = DateTime.now().millisecondsSinceEpoch;
    final diffSeconds = (now - _time) / 1000;
    if (diffSeconds / 60 <= 1) {
      return '1 min ago';
    } else if (diffSeconds / 60 >= 2 && diffSeconds / 3600 < 1) {
      final _di = diffSeconds / 60;
      final di = _di.toInt();
      return '$di mins ago';
    } else if (diffSeconds / 3600 >= 1 && diffSeconds / 3600 < 2) {
      return '1 hour ago';
    } else if (diffSeconds / 3600 >= 2 && diffSeconds / 3600 < 24) {
      final _di = diffSeconds / 3600;
      final di = _di.toInt();
      return '$di hours ago';
    } else if (diffSeconds / (3600 * 24) >= 1 &&
        diffSeconds / (3600 * 24) < 2) {
      return '1 day ago';
    } else if (diffSeconds / (3600 * 24) >= 2 &&
        diffSeconds / (3600 * 24) <= 7) {
      final _di = diffSeconds / (3600 * 24);
      final di = _di.toInt();
      return '$di days ago';
    } else if (diffSeconds / (3600 * 24) > 7 &&
        diffSeconds / (3600 * 24) <= 365) {
      return time.month + time.day;
    } else if (diffSeconds / (3600 * 24) > 365) {
      return time.year + time.month + time.day;
    }
  }
}
