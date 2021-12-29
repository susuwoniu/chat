import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:flutter_chat_ui/src/models/emoji_enlargement_behavior.dart';
import 'package:flutter_chat_ui/src/util.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_chat_theme.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_user.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class BubbleWidget extends StatelessWidget {
  Widget thechild;
  types.Message message;
  bool nextMessageInGroup;
  BubbleWidget(
    this.thechild, {
    required this.message,
    required this.nextMessageInGroup,
  });
  @override
  build(BuildContext context) {
    final _user = InheritedUser.of(context).user;
    final _currentUserIsAuthor = _user.id == message.author.id;

    final _messageBorderRadius =
        InheritedChatTheme.of(context).theme.messageBorderRadius;
    final _borderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(
        _currentUserIsAuthor || nextMessageInGroup ? _messageBorderRadius : 0,
      ),
      bottomRight: Radius.circular(_currentUserIsAuthor
          ? nextMessageInGroup
              ? _messageBorderRadius
              : 0
          : _messageBorderRadius),
      topLeft: Radius.circular(_messageBorderRadius),
      topRight: Radius.circular(_messageBorderRadius),
    );
    return Stack(
      children: [
        Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            color: message.id == "preview"
                ? InheritedChatTheme.of(context)
                    .theme
                    .primaryColor
                    .withOpacity(0.7)
                : (!_currentUserIsAuthor ||
                        message.type == types.MessageType.image
                    ? InheritedChatTheme.of(context).theme.secondaryColor
                    : InheritedChatTheme.of(context).theme.primaryColor),
          ),
          child: ClipRRect(
            borderRadius: _borderRadius,
            child: thechild,
          ),
        ),
        // Positioned(
        //   bottom: 6.0,
        //   right: 0,
        //   child: IconButton(
        //       onPressed: () {}, icon: Icon(Icons.close, color: Colors.white)),
        // )
      ],
    );
  }
}
