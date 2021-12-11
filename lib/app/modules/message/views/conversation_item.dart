import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/widges/avatar.dart';
import 'time_ago.dart';
import 'unread_count.dart';

Widget conversationItemView(
    {required BuildContext context,
    required String name,
    required String preview,
    required DateTime updatedAt,
    required int unreadCount,
    required int index,
    String? avatar,
    void Function(int index)? onTap}) {
  final _width = MediaQuery.of(context).size.width;
  final _height = MediaQuery.of(context).size.height;
  final _paddingTop = _height * 0.02;

  return GestureDetector(
    onTap: () {
      if (onTap != null) onTap(index);
    },
    child: Container(
        margin: EdgeInsets.symmetric(horizontal: _width * 0.04),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
            ),
          ),
        ),
        child: Row(children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: _width * 0.03),
              padding: EdgeInsets.symmetric(vertical: _paddingTop),
              child: Avatar(name: name, uri: avatar)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 6),
                                child: Text(name,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                            Row(children: [
                              Text('💗', style: TextStyle(fontSize: 18)),
                              SizedBox(width: 4),
                              Text(
                                  AuthProvider.to.account.value.likeCount
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.pink[300],
                                      fontWeight: FontWeight.bold))
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TimeAgo(updatedAt: updatedAt)
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(preview,
                        style: TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).hintColor)),
                    UnreadCount(unreadCount: unreadCount),
                  ],
                ),
              ),
            ],
          )),
        ])),
  );
}
