import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../home/views/author_name.dart';

class SingleExplore extends StatelessWidget {
  final String postTemplateId;
  final PostTemplatesEntity postTemplate;
  final int? index;

  final Function onTap;
  SingleExplore({
    required this.postTemplateId,
    required this.postTemplate,
    required this.onTap,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTap();
        },
        child: Row(children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            padding: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Container(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(postTemplate.title,
                    maxLines: 1,
                    minFontSize: 17,
                    maxFontSize: 17,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ))),
          )),
        ]));
  }
}
