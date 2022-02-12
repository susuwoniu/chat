import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/common.dart';
import 'package:chat/app/routes/app_pages.dart';

class AuthorName extends StatelessWidget {
  final String authorName;
  final String? avatarUri;
  final int index;
  final String accountId;
  final double avatarSize;
  final double nameSize;
  final Color color;

  AuthorName(
      {Key? key,
      required this.authorName,
      this.avatarUri,
      this.avatarSize = 24,
      this.nameSize = 20,
      required this.index,
      required this.accountId,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Avatar(
          size: avatarSize,
          name: authorName,
          uri: avatarUri,
          onTap: () {
            if (AuthProvider.to.accountId == accountId) {
              RouterProvider.to.toMe();
            } else {
              Get.toNamed(Routes.OTHER, arguments: {"id": accountId});
            }
          }),
      SizedBox(width: 15),
      Expanded(
          child: Text(
        authorName,
        key: Key('$index-text'),
        style: TextStyle(
            fontSize: nameSize, color: color, overflow: TextOverflow.ellipsis),
      )),
      SizedBox(width: 50)
    ]);
  }
}
