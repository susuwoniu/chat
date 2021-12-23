import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widgets/max_text.dart';
import 'package:chat/config/config.dart';
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
    final screenHeight = size.height;
    return Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.1),
        child: GestureDetector(
          onTap: () {
            onPressed();
          },
          child: Stack(clipBehavior: Clip.none, children: [
            Positioned(
                left: 30,
                bottom: 60,
                child: Text("💭", style: TextStyle(fontSize: 50))),
            Container(
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
          ]),
        ));
  }
}
