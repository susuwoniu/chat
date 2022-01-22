import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
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
    required bool isLast,
    required String id,
    String? avatar,
    int likeCount = 0,
    void Function(int index)? onTap}) {
  return Column(children: [
    ListTile(
      onTap: () {
        if (onTap != null) {
          onTap(index);
        }
      },
      contentPadding: EdgeInsets.fromLTRB(10, 3, 13, 3),
      leading: Avatar(
          name: name,
          uri: avatar,
          size: 25,
          onTap: () {
            if (id == AuthProvider.to.accountId) {
              RouterProvider.to.toMe();
              return;
            }
            Get.toNamed(Routes.OTHER, arguments: {"accountId": id});
          }),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              Flexible(
                  child: Container(
                      child: Text(name,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)))),
              LikeCount(
                count: likeCount,
                iconSize: 16,
                fontSize: 14,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 15),
            ])),
        TimeAgo(updatedAt: updatedAt),
      ]),
      subtitle: Container(
          padding: EdgeInsets.symmetric(vertical: 3),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Text(preview,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                        color: Theme.of(context).hintColor))),
            CountBubble(count: unreadCount),
          ])),
    ),
    !isLast ? Divider(height: 1) : SizedBox.shrink()
  ]);
}
