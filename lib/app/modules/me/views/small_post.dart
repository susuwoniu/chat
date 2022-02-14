import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:auto_size_text/auto_size_text.dart';

final imDomain = AppConfig().config.imDomain;

class SmallPost extends StatelessWidget {
  final String? type;
  final String postId;
  final String? accountId;
  final PostEntity post;

  final Function onTap;
  SmallPost({
    this.type = 'me',
    required this.postId,
    this.accountId,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double paddingLeft = 13;
    final double paddingTop = 12;
    final backgroundColor = post.backgroundColor;
    final frontColor = post.color;
    final content = post.content;
    return Container(
        child: GestureDetector(
            onTap: () {
              onTap();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(
                  paddingLeft, paddingTop, paddingLeft, paddingTop),
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(backgroundColor),
              ),
              child: AutoSizeText(content,
                  maxLines: 8,
                  minFontSize: 16,
                  maxFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(frontColor),
                  )),
            )));
  }
}
