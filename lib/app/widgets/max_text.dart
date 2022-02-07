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
      final double minFontsize = 20;
      final maxLines = (constraints.maxHeight / minFontsize / 1.8).floor();
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.MY_SINGLE_POST,
                        arguments: {"id": id}),
                    child: Text("More".tr + " >>",
                        style: TextStyle(
                          color: style == null
                              ? Theme.of(context).colorScheme.onPrimary
                              : style.color!,
                          fontSize: minFontsize - 8,
                          decorationColor: style == null
                              ? Theme.of(context).colorScheme.onPrimary
                              : style.color,
                          decoration: TextDecoration.underline,
                        )),
                  ))
            ],
          )
        ]),
      );
    }),
  );
}
