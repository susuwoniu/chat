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
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Row(children: [
              Text('# ',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
              AutoSizeText(postTemplate.title,
                  maxLines: 1,
                  minFontSize: 16,
                  maxFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
            ]),
          )),
        ]));
  }
}
