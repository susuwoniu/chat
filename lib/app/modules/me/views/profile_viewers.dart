import 'package:flutter/material.dart';
import '../../message/views/unread_count.dart';

class ProfileViewers extends StatelessWidget {
  final int totalViewersCount;
  final int newViewersCount;
  final void Function() onPressed;

  ProfileViewers({
    Key? key,
    required this.totalViewersCount,
    required this.newViewersCount,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          child: Column(children: [
            Stack(clipBehavior: Clip.none, children: [
              Positioned(
                  right: newViewersCount > 9 ? -33 : -20,
                  top: -13,
                  child: CountBubble(count: newViewersCount, type: "viewers")),
              Text(totalViewersCount.toString(),
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)),
            ]),
            Text("看过我",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold))
          ]),
          decoration: BoxDecoration(
              color: Colors.white54, borderRadius: BorderRadius.circular(30)),
        ));
  }
}
