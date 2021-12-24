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
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    return Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            onPressed();
          },
          child: Container(
            height: 60,
            width: screenWidth * 0.88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                  onPressed: () async {},
                  child: isLogin
                      ? Avatar(
                          size: 20,
                          uri: account.avatar,
                          name: account.name,
                          onTap: () async {
                            RouterProvider.to.toMe();
                          },
                        )
                      : Text("🤠",
                          style: const TextStyle(
                              fontSize: 32, color: Colors.white))),
            ]),
          ),
        ));
  }
}
