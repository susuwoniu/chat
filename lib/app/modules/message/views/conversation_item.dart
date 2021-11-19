import 'package:flutter/material.dart';

Widget conversationItemView(
    {required BuildContext context,
    required String title,
    required String? lastMessage,
    required String? updatedAtStr,
    required int unreadCount,
    required int index,
    void Function(int index)? onTap}) {
  var subtitle = lastMessage ?? '';

  return GestureDetector(
    onTap: () {
      if (onTap != null) onTap(index);
    },
    child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("avatar")),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(title,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                  unreadCount > 0
                      ? Text(unreadCount.toString(),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.red))
                      : Text(""),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(subtitle,
                          style: TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                              color: Theme.of(context).hintColor)),
                    ),
                    Text(updatedAtStr.toString(),
                        style: TextStyle(
                            fontSize: 14, color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
            ],
          )),
        ])),
  );
}
