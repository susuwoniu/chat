import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
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
    required String id,
    String? avatar,
    int likeCount = 0,
    void Function(int index)? onTap}) {
  final size = MediaQuery.of(context).size;
  final paddingLeft = size.width * 0.022;
  return Container(
      padding: EdgeInsets.symmetric(
          horizontal: paddingLeft, vertical: paddingLeft * 1.8),
      margin: EdgeInsets.symmetric(horizontal: paddingLeft),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(children: [
        Container(
          child: Avatar(
              name: name,
              uri: avatar,
              size: 25,
              onTap: () {
                Get.toNamed(Routes.OTHER, arguments: {"accountId": id});
              }),
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
                      text: likeCount.toString(),
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
