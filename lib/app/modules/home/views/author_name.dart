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

  AuthorName({
    Key? key,
    required this.authorName,
    this.avatarUri,
    required this.index,
    required this.accountId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Avatar(
          size: 24,
          name: authorName,
          uri: avatarUri,
          onTap: () {
            if (AccountStoreProvider.to.getString(STORAGE_ACCOUNT_ID_KEY) ==
                accountId) {
              RouterProvider.to.toMe();
            } else {
              Get.toNamed(Routes.OTHER, arguments: {"accountId": accountId});
            }
          }),
      SizedBox(width: 15),
      Expanded(
          child: Text(
        authorName,
        key: Key('$index-text'),
        style: const TextStyle(
            fontSize: 22, color: Colors.white, overflow: TextOverflow.ellipsis),
      )),
      SizedBox(width: 10)
    ]);
  }
}
