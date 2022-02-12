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

  PostSingleViewer(
      {Key? key,
      this.img,
      required this.onPressed,
      required this.name,
      required this.viewerId,
      required this.likeCount,
      required this.isLast,
      this.isVip = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 21),
        child: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Row(children: [
                Stack(clipBehavior: Clip.none, children: [
                  Avatar(name: name, uri: img, size: 25),
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
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w500),
                              )),
                              SizedBox(
                                width: 8,
                              ),
                              LikeCount(
                                  count: likeCount,
                                  backgroundColor: Colors.black12,
                                  fontSize: 14,
                                  iconSize: 13)
                            ]),
                        SizedBox(
                          height: 6,
                        ),
                        Text('viewed_your_post'.tr,
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 13))
                      ]),
                )
              ])),
          !isLast ? Divider(height: 1) : SizedBox.shrink()
        ]));
  }
}
