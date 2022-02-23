import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:get/get.dart';
import 'package:chat/common.dart';
import 'time_ago.dart';
import 'unread_count.dart';
import '../../me/views/like_count.dart';

class ConversationItemView extends StatelessWidget {
  final BuildContext context;
  final String name;
  final String preview;
  final DateTime updatedAt;
  final int unreadCount;
  final int index;
  final bool isLast;
  final String id;
  final String? avatar;
  final int likeCount;
  final void Function(int index)? onTap;
  final void Function(int index) onDismiss;

  const ConversationItemView({
    Key? key,
    required this.context,
    required this.name,
    required this.preview,
    required this.updatedAt,
    required this.unreadCount,
    required this.index,
    required this.isLast,
    required this.id,
    this.avatar,
    this.likeCount = 0,
    this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        direction: DismissDirection.endToStart,
        key: Key(id),
        dismissThresholds: {DismissDirection.endToStart: 0.4},
        onDismissed: (direction) {
          onDismiss(index);
        },
        confirmDismiss: (_) async {
          return _onConfirmDismiss(index);
        },
        background: Container(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {},
                child: Text(
                  'Delete'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
            color: Colors.red[400]),
        child: Container(
            child: Column(children: [
          ListTile(
            onLongPress: () {},
            hoverColor: Colors.transparent,
            selectedColor: Colors.transparent,
            onTap: () {
              if (onTap != null) {
                onTap!(index);
              }
            },
            contentPadding: EdgeInsets.fromLTRB(10, 3, 13, 3),
            leading: Avatar(
                name: name,
                uri: avatar,
                size: 28,
                onTap: () {
                  if (id == AuthProvider.to.accountId) {
                    RouterProvider.to.toMe();
                    return;
                  }
                  Get.toNamed(Routes.OTHER, arguments: {"id": id});
                }),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    )))),
                        SizedBox(width: 6),
                        LikeCount(
                            count: likeCount,
                            backgroundColor: Colors.black12,
                            fontSize: 13,
                            iconSize: 12),
                        SizedBox(width: 10),
                      ])),
                  TimeAgo(updatedAt: updatedAt),
                ]),
            subtitle: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(preview,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 14.5,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.grey.shade500))),
                      SizedBox(width: 15),
                      CountBubble(count: unreadCount),
                    ])),
          ),
          !isLast ? Divider(height: 1) : SizedBox.shrink()
        ])));
  }

  Future<bool?> _onConfirmDismiss(int index) async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              content: Text("Confirm_to_delete?".tr),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("Confirm".tr),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  child: Text("Cancel".tr),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            ));
  }
}
