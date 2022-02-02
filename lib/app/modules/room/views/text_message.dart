import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_link_previewer/flutter_link_previewer.dart'
    show LinkPreview, regexLink;
import 'package:flutter_chat_ui/src/models/emoji_enlargement_behavior.dart';
import 'package:flutter_chat_ui/src/util.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_chat_theme.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_user.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:chat/common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chat/app/common/link.dart';

/// A class that represents text message widget with optional link preview
class TextMessage extends StatelessWidget {
  /// Creates a text message widget from a [types.TextMessage] class
  const TextMessage(
      {Key? key,
      required this.emojiEnlargementBehavior,
      required this.hideBackgroundOnEmojiMessages,
      required this.message,
      this.onPreviewDataFetched,
      required this.usePreviewData,
      required this.showName,
      this.maxTextLength})
      : super(key: key);
  final int? maxTextLength;

  /// See [Message.emojiEnlargementBehavior]
  final EmojiEnlargementBehavior emojiEnlargementBehavior;

  /// See [Message.hideBackgroundOnEmojiMessages]
  final bool hideBackgroundOnEmojiMessages;

  /// [types.TextMessage]
  final types.TextMessage message;

  /// See [LinkPreview.onPreviewDataFetched]
  final void Function(types.TextMessage, types.PreviewData)?
      onPreviewDataFetched;

  /// Show user name for the received message. Useful for a group chat.
  final bool showName;

  /// Enables link (URL) preview
  final bool usePreviewData;

  void _onPreviewDataFetched(types.PreviewData previewData) {
    if (message.previewData == null) {
      onPreviewDataFetched?.call(message, previewData);
    }
  }

  Widget _linkPreview(
    types.User user,
    double width,
    BuildContext context,
  ) {
    final bodyTextStyle = user.id == message.author.id
        ? InheritedChatTheme.of(context).theme.sentMessageBodyTextStyle
        : InheritedChatTheme.of(context).theme.receivedMessageBodyTextStyle;
    final linkDescriptionTextStyle = user.id == message.author.id
        ? InheritedChatTheme.of(context)
            .theme
            .sentMessageLinkDescriptionTextStyle
        : InheritedChatTheme.of(context)
            .theme
            .receivedMessageLinkDescriptionTextStyle;
    final linkTitleTextStyle = user.id == message.author.id
        ? InheritedChatTheme.of(context).theme.sentMessageLinkTitleTextStyle
        : InheritedChatTheme.of(context)
            .theme
            .receivedMessageLinkTitleTextStyle;

    final color = getUserAvatarNameColor(message.author,
        InheritedChatTheme.of(context).theme.userAvatarNameColors);
    final name = getUserName(message.author);

    return LinkPreview(
      enableAnimation: true,
      header: showName ? name : null,
      headerStyle: InheritedChatTheme.of(context)
          .theme
          .userNameTextStyle
          .copyWith(color: color),
      linkStyle: bodyTextStyle,
      metadataTextStyle: linkDescriptionTextStyle,
      metadataTitleStyle: linkTitleTextStyle,
      onPreviewDataFetched: _onPreviewDataFetched,
      padding: EdgeInsets.symmetric(
        horizontal:
            InheritedChatTheme.of(context).theme.messageInsetsHorizontal,
        vertical: InheritedChatTheme.of(context).theme.messageInsetsVertical,
      ),
      previewData: message.previewData,
      text: message.text,
      textStyle: bodyTextStyle,
      width: width,
    );
  }

  Widget _textWidgetBuilder(
    types.User user,
    BuildContext context,
    bool enlargeEmojis,
  ) {
    final theme = InheritedChatTheme.of(context).theme;
    final color =
        getUserAvatarNameColor(message.author, theme.userAvatarNameColors);
    final name = getUserName(message.author);
    final defaultColor = user.id == message.author.id
        ? theme.sentMessageBodyTextStyle.color!
        : theme.receivedMessageBodyTextStyle.color!;
    final defaultCodeColor =
        user.id == message.author.id ? Colors.greenAccent : Colors.redAccent;
    final defaultTextStyle = user.id == message.author.id
        ? enlargeEmojis
            ? theme.sentEmojiMessageTextStyle
            : theme.sentMessageBodyTextStyle
        : enlargeEmojis
            ? theme.receivedEmojiMessageTextStyle
            : theme.receivedMessageBodyTextStyle;
    final negotiveTextStyle = user.id == message.author.id
        ? enlargeEmojis
            ? theme.receivedEmojiMessageTextStyle
            : theme.receivedMessageBodyTextStyle
        : enlargeEmojis
            ? theme.sentEmojiMessageTextStyle
            : theme.sentMessageBodyTextStyle;
    var finalText = message.text;
    if (maxTextLength != null) {
      if (message.text.length > maxTextLength!) {
        finalText = message.text.substring(0, maxTextLength) + "...";
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (showName)
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.userNameTextStyle.copyWith(color: color),
          ),
        ),
      MarkdownBody(
        data: finalText,
        selectable: true,
        onTapLink: (String text, String? href, String? title) async {
          // if internal link
          await openLink(href);
        },
        styleSheet: MarkdownStyleSheet(
          a: TextStyle(
            shadows: [Shadow(color: defaultColor, offset: Offset(0, -5))],
            color: Colors.transparent,
            decoration: TextDecoration.underline,
            decorationColor: defaultColor,
          ),
          pPadding: EdgeInsets.zero,
          code: theme.sentMessageBodyTextStyle.copyWith(
              backgroundColor: Colors.transparent,
              fontFamily: 'monospace',
              fontSize: theme.sentMessageBodyTextStyle.fontSize! * 0.85,
              color: defaultCodeColor),
          codeblockPadding: const EdgeInsets.all(0),
          codeblockDecoration: BoxDecoration(
            color: Colors.transparent,
          ),
          h1: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: defaultColor),
          h2: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: defaultColor),
          h3: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: defaultColor),
          h4: defaultTextStyle,
          h5: defaultTextStyle,
          h6: defaultTextStyle,
          em: TextStyle(fontStyle: FontStyle.italic, color: defaultColor),
          strong: TextStyle(fontWeight: FontWeight.bold, color: defaultColor),
          del: TextStyle(
              decoration: TextDecoration.lineThrough, color: defaultColor),
          img: defaultTextStyle,
          checkbox: defaultTextStyle.copyWith(color: defaultCodeColor),
          listBullet: defaultTextStyle,
          tableHead:
              TextStyle(fontWeight: FontWeight.w600, color: defaultColor),
          tableBody: defaultTextStyle,
          tableBorder: TableBorder.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          blockquoteDecoration: BoxDecoration(
            border: Border(
                left: BorderSide(
              color: defaultColor,
              width: 2,
            )),
          ),
          blockquotePadding: EdgeInsets.only(left: 10),
          p: defaultTextStyle,
        ),
      )
      // SelectableText(
      //   message.text,
      //   style: user.id == message.author.id
      //       ? enlargeEmojis
      //           ? theme.sentEmojiMessageTextStyle
      //           : theme.sentMessageBodyTextStyle
      //       : enlargeEmojis
      //           ? theme.receivedEmojiMessageTextStyle
      //           : theme.receivedMessageBodyTextStyle,
      //   textWidthBasis: TextWidthBasis.longestLine,
      // ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final _enlargeEmojis =
        emojiEnlargementBehavior != EmojiEnlargementBehavior.never &&
            isConsistsOfEmojis(emojiEnlargementBehavior, message);
    final _theme = InheritedChatTheme.of(context).theme;
    final _user = InheritedUser.of(context).user;
    final _width = MediaQuery.of(context).size.width;

    if (usePreviewData && onPreviewDataFetched != null) {
      final urlRegexp = RegExp(regexLink, caseSensitive: false);
      final matches = urlRegexp.allMatches(message.text);

      if (matches.isNotEmpty) {
        return _linkPreview(_user, _width, context);
      }
    }

    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: _enlargeEmojis && hideBackgroundOnEmojiMessages
              ? 0.0
              : _theme.messageInsetsHorizontal,
          vertical: _theme.messageInsetsVertical,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Flexible(
            child: _textWidgetBuilder(_user, context, _enlargeEmojis),
          ),
        ]));
  }
}
