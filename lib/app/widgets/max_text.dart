import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import './single_line_markdown_body.dart';
import 'package:get/get.dart';
import 'package:chat/app/routes/app_pages.dart';

// 外层不能套Container
// 只能放在Column的直接子元素中
Widget MaxText(String text, BuildContext context,
    {TextStyle? style, TextAlign? textAlign, required String id}) {
  return Flexible(
    child: LayoutBuilder(builder: (context, constraints) {
      final double minFontsize = 22;
      final maxLines = (constraints.maxHeight / minFontsize / 1.5).floor();
      return AutoSizeText(
        text,
        style: style,
        maxLines: maxLines,
        minFontSize: minFontsize,
        overflowReplacement: Column(mainAxisSize: MainAxisSize.min, children: [
          AutoSizeText(
            text,
            style: style,
            maxLines: maxLines - 1,
            minFontSize: minFontsize,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.MY_SINGLE_POST,
                        arguments: {"id": id}),
                    child: Text("查看全文 >>",
                        style: TextStyle(
                            shadows: [
                              Shadow(color: Colors.white, offset: Offset(0, -5))
                            ],
                            color: Colors.transparent,
                            fontSize: minFontsize - 6,
                            decorationColor: Colors.white,
                            decoration: TextDecoration.underline)),
                  ))
            ],
          )
        ]),
      );
    }),
  );
}
