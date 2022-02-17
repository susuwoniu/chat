import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../home/views/author_name.dart';

final imDomain = AppConfig().config.imDomain;

class SmallPost extends StatelessWidget {
  final String? type;
  final String postId;
  final String? accountId;
  final PostEntity post;
  final String? name;
  final String? uri;
  final int? index;

  final Function onTap;
  SmallPost(
      {this.type = 'me',
      required this.postId,
      this.accountId,
      required this.post,
      required this.onTap,
      this.index,
      this.name,
      this.uri});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = post.backgroundColor;
    final frontColor = post.color;
    final content = post.content;
    return GestureDetector(
        onTap: () {
          onTap();
        },
        child: Row(children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 13),
            padding: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(backgroundColor),
            ),
            child: Column(children: [
              type == 'square'
                  ? AuthorName(
                      color: Color(post.color),
                      avatarSize: 14,
                      nameSize: 14,
                      accountId: post.accountId,
                      authorName: name ?? '',
                      avatarUri: uri,
                      index: index!)
                  : SizedBox.shrink(),
              Container(
                  padding: EdgeInsets.only(top: 8),
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(content,
                      maxLines: type == 'square' ? 7 : 9,
                      minFontSize: 16,
                      maxFontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(frontColor),
                      ))),
            ]),
          )),
        ]));
  }
}
