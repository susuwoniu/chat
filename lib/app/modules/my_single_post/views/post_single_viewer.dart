import 'package:chat/app/widgets/avatar.dart';
import 'package:flutter/material.dart';
import '../../me/views/like_count.dart';
import 'package:get/get.dart';
import '../../me/views/vip_icon.dart';

class PostSingleViewer extends StatelessWidget {
  final String? img;
  final String name;
  final String viewerId;
  final int likeCount;
  final bool isLast;
  final bool isVip;
  final Function() onPressed;
  final bool isBlock;
  final double margin;
  final double iconSize;
  final double fontSize;

  PostSingleViewer(
      {Key? key,
      this.img,
      required this.onPressed,
      required this.name,
      required this.viewerId,
      required this.likeCount,
      required this.isLast,
      this.isVip = false,
      this.isBlock = false,
      this.margin = 21,
      this.iconSize = 25,
      this.fontSize = 14})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: margin),
        child: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(children: [
                Stack(clipBehavior: Clip.none, children: [
                  Avatar(
                      name: name,
                      uri: img,
                      size: iconSize,
                      onTap: () {
                        onPressed();
                      }),
                  Positioned(
                    bottom: 0,
                    right: -6,
                    child: isVip
                        ? VipIcon(
                            iconSize: 22,
                          )
                        : SizedBox.shrink(),
                  )
                ]),
                SizedBox(
                  width: 13,
                ),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                  child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: fontSize,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w500),
                              )),
                              SizedBox(
                                width: 8,
                              ),
                              isBlock
                                  ? SizedBox.shrink()
                                  : LikeCount(
                                      count: likeCount,
                                      backgroundColor: Colors.black12,
                                      fontSize: 13,
                                      iconSize: 12)
                            ]),
                        isBlock
                            ? SizedBox.shrink()
                            : Container(
                                margin: EdgeInsets.only(top: 6),
                                child: Text('viewed_your_post'.tr,
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 13)))
                      ]),
                ),
                isBlock
                    ? Container(
                        margin: EdgeInsets.only(left: 6),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 0)),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.grey.shade300),
                                splashFactory: NoSplash.splashFactory),
                            child: Text(
                              'Unblock'.tr,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13),
                            ),
                            onPressed: () {
                              onPressed();
                            }))
                    : SizedBox.shrink(),
              ])),
          !isLast ? Divider(height: 1) : SizedBox.shrink()
        ]));
  }
}