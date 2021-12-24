import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:chat/types/account.dart';

class ChatBox extends StatelessWidget {
  final bool isLogin;
  final AccountEntity account;
  final String postId;
  final Function onPressed;

  ChatBox({
    Key? key,
    required this.isLogin,
    required this.account,
    required this.postId,
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
        // width: screenWidth * 0.88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 4),
                  alignment: Alignment.centerLeft),
              onPressed: () async {},
              child: Avatar(
                elevation: 0,
                size: 20,
                uri: account.avatar,
                child: isLogin
                    ? null
                    : const Image(image: AssetImage('assets/avatar.png')),
                name: isLogin ? account.name : "--",
                onTap: () async {
                  RouterProvider.to.toMe();
                },
              ))
        ]),
      ),
    );
  }
}
