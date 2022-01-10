import 'package:flutter/material.dart';
import 'package:chat/common.dart';

final imDomain = AppConfig().config.imDomain;

class SmallPost extends StatelessWidget {
  final String? type;
  final String postId;
  final String? accountId;
  final String content;
  final int backgroundColor;
  final Function onTap;
  SmallPost({
    this.type = 'me',
    required this.postId,
    this.accountId,
    required this.content,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final double paddingLeft = 13;
    final double paddingTop = 12;
    return Container(
        height: _width * 0.5,
        width: _width * 0.4,
        child: GestureDetector(
            onTap: () {
              onTap();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(
                  paddingLeft, paddingTop, paddingLeft, paddingTop),
              padding: EdgeInsets.all(14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(backgroundColor),
              ),
              height: _width * 0.5,
              width: _width * 0.4,
              child: Text(content,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                  )),
            )));

    // SizedBox(
    //     width: double.infinity,
    //     child: Wrap(
    //         alignment: WrapAlignment.spaceBetween,
    //         children: _myPostsList),
    //   );
    // });
  }
}
