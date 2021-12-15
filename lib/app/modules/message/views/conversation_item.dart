import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'time_ago.dart';
import 'unread_count.dart';
import '../../me/views/like_count.dart';

Widget conversationItemView(
    {required BuildContext context,
    required String name,
    required String preview,
    required DateTime updatedAt,
    required int unreadCount,
    required int index,
    String? avatar,
    void Function(int index)? onTap}) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(children: [
        Container(
          child: Avatar(name: name, uri: avatar, size: 25),
          padding: EdgeInsets.only(right: 10),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                            child: Text(name,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)))),
                    LikeCount(
                      text: AuthProvider.to.account.value.likeCount.toString(),
                      iconSize: 16,
                      fontSize: 14,
                      backgroundColor: Colors.transparent,
                    ),
                  ])),
              TimeAgo(updatedAt: updatedAt),
            ]),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(preview,
                            style: TextStyle(
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                                color: Theme.of(context).hintColor))),
                    CountBubble(count: unreadCount),
                  ]),
            ),
          ],
        )),
      ]));
}
