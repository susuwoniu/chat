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
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 7),
            child: Text(name,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ),
          Icon(Icons.stars_rounded,
              color: vip ? Colors.pink : Colors.white, size: 34),
        ],
      ),
    );
  }
}