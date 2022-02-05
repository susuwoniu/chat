import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:chat/common.dart';

class ChatBox extends StatelessWidget {
  final bool isLogin;
  final AccountEntity account;
  final String postId;
  final Function onPressed;
  final String postAuthorName;
  ChatBox({
    Key? key,
    required this.isLogin,
    required this.account,
    required this.postId,
    required this.postAuthorName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          TextButton(
              style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.only(left: 6, right: 10),
                  alignment: Alignment.centerLeft),
              onPressed: () async {
                RouterProvider.to.toMe();
              },
              child: Avatar(
                elevation: 0,
                size: 18,
                uri: account.avatar,
                child: isLogin
                    ? null
                    : const Image(image: AssetImage('assets/avatar.png')),
                name: isLogin ? account.name : "--",
              )),
          Expanded(
              child: Text("私聊回应 @$postAuthorName:",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15))),
          SizedBox(width: 10)
        ]),
      ),
    );
  }
}
