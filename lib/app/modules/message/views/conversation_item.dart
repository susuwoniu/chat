import 'package:flutter/material.dart';
import 'package:chat/app/widges/avatar.dart';

Widget conversationItemView(
    {required BuildContext context,
    required String name,
    required String preview,
    required DateTime updatedAt,
    required int unreadCount,
    required int index,
    String? avatar,
    void Function(int index)? onTap}) {
  return GestureDetector(
    onTap: () {
      if (onTap != null) onTap(index);
    },
    child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Avatar(name: name, uri: avatar)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(name,
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
                      child: Text(preview,
                          style: TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                              color: Theme.of(context).hintColor)),
                    ),
                    Text(updatedAt.toString(),
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
