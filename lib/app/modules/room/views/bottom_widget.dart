import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/src/models/send_button_visibility_mode.dart';
import 'package:flutter_chat_ui/src/widgets/attachment_button.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_chat_theme.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_l10n.dart';
import 'package:flutter_chat_ui/src/widgets/send_button.dart';

class NewLineIntent extends Intent {
  const NewLineIntent();
}

class SendMessageIntent extends Intent {
  const SendMessageIntent();
}

/// A class that represents bottom bar widget with a text field, attachment and
/// send buttons inside. By default hides send button when text field is empty.
class BottomWidget extends StatefulWidget {
  /// Creates [Input] widget
  const BottomWidget(
      {Key? key,
      this.isAttachmentUploading,
      this.onAttachmentPressed,
      this.onCameraPressed,
      required this.onSendPressed,
      this.onTextChanged,
      this.onTextFieldTap,
      required this.sendButtonVisibilityMode,
      this.onCancelQuote,
      this.replyTo})
      : super(key: key);

  /// See [AttachmentButton.onPressed]
  final void Function()? onAttachmentPressed;

  /// See [AttachmentButton.onPressed]
  final void Function()? onCameraPressed;

  final void Function()? onCancelQuote;

  /// Whether attachment is uploading. Will replace attachment button with a
  /// [CircularProgressIndicator]. Since we don't have libraries for
  /// managing media in dependencies we have no way of knowing if
  /// something is uploading so you need to set this manually.
  final bool? isAttachmentUploading;
  final String? replyTo;

  /// Will be called on [SendButton] tap. Has [types.PartialText] which can
  /// be transformed to [types.TextMessage] and added to the messages list.
  final void Function(types.PartialText) onSendPressed;

  /// Will be called whenever the text inside [TextField] changes
  final void Function(String)? onTextChanged;

  /// Will be called on [TextField] tap
  final void Function()? onTextFieldTap;

  /// Controls the visibility behavior of the [SendButton] based on the
  /// [TextField] state inside the [Input] widget.
  /// Defaults to [SendButtonVisibilityMode.editing].
  final SendButtonVisibilityMode sendButtonVisibilityMode;

  @override
  _InputState createState() => _InputState();
}

/// [Input] widget state
class _InputState extends State<BottomWidget> {
  final _inputFocusNode = FocusNode();
  bool _sendButtonVisible = false;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.sendButtonVisibilityMode == SendButtonVisibilityMode.editing) {
      _sendButtonVisible = _textController.text.trim() != '';
      _textController.addListener(_handleTextControllerChange);
    } else {
      _sendButtonVisible = true;
    }
  }

  @override
  void dispose() {
    _inputFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleSendPressed() {
    final trimmedText = _textController.text.trim();
    if (trimmedText != '') {
      final _partialText = types.PartialText(text: trimmedText);
      widget.onSendPressed(_partialText);
      _textController.clear();
    }
  }

  void _handleTextControllerChange() {
    setState(() {
      _sendButtonVisible = _textController.text.trim() != '';
    });
  }

  Widget _leftWidget() {
    if (widget.isAttachmentUploading == true) {
      return Container(
        height: 24,
        margin: const EdgeInsets.only(right: 16),
        width: 24,
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          strokeWidth: 1.5,
          // valueColor: AlwaysStoppedAnimation<Color>(
          //   InheritedChatTheme.of(context).theme.inputTextColor,
          // ),
        ),
      );
    } else {
      return Container(
        height: 24,
        margin: const EdgeInsets.only(right: 16),
        width: 24,
        child: IconButton(
          icon: Icon(
            Icons.photo_camera,
            // color: InheritedChatTheme.of(context).theme.inputTextColor,
          ),
          onPressed: widget.onCameraPressed,
          padding: EdgeInsets.zero,
          tooltip:
              InheritedL10n.of(context).l10n.attachmentButtonAccessibilityLabel,
        ),
      );
    }
  }

  Widget _rightWidget() {
    return Row(children: [
      Container(
        height: 24,
        margin: const EdgeInsets.only(left: 0),
        width: 24,
        child: IconButton(
          icon: Icon(
            Icons.image,
            // color: InheritedChatTheme.of(context).theme.inputTextColor,
          ),
          onPressed: widget.onAttachmentPressed,
          padding: EdgeInsets.zero,
          tooltip:
              InheritedL10n.of(context).l10n.attachmentButtonAccessibilityLabel,
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final _query = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => _inputFocusNode.requestFocus(),
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): const SendMessageIntent(),
          LogicalKeySet(LogicalKeyboardKey.enter, LogicalKeyboardKey.alt):
              const NewLineIntent(),
          LogicalKeySet(LogicalKeyboardKey.enter, LogicalKeyboardKey.shift):
              const NewLineIntent(),
        },
        child: Actions(
          actions: {
            SendMessageIntent: CallbackAction<SendMessageIntent>(
              onInvoke: (SendMessageIntent intent) => _handleSendPressed(),
            ),
            NewLineIntent: CallbackAction<NewLineIntent>(
              onInvoke: (NewLineIntent intent) {
                final _newValue = '${_textController.text}\r\n';
                _textController.value = TextEditingValue(
                  text: _newValue,
                  selection: TextSelection.fromPosition(
                    TextPosition(offset: _newValue.length),
                  ),
                );
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: Padding(
              padding: InheritedChatTheme.of(context).theme.inputPadding,
              child: Column(children: [
                widget.replyTo != null
                    ? Container(
                        color: Colors.black.withOpacity(0.08),
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "回应 @${widget.replyTo}：",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14),
                            )),
                            IconButton(
                              onPressed: widget.onCancelQuote,
                              icon: Icon(
                                Icons.close,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            )
                          ],
                        ))
                    : SizedBox.shrink(),
                Container(
                  // borderRadius:
                  //     InheritedChatTheme.of(context).theme.inputBorderRadius,
                  // color: Colors.black.withOpacity(0.06),
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.black.withOpacity(0.06),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      12,
                      12,
                      12,
                      12,
                    ),
                    margin: EdgeInsets.fromLTRB(
                      10 + _query.padding.left,
                      10,
                      10 + _query.padding.right,
                      _query.viewInsets.bottom + _query.padding.bottom,
                    ),
                    child: Row(
                      children: [
                        if (widget.onAttachmentPressed != null) _leftWidget(),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            // cursorColor: InheritedChatTheme.of(context)
                            //     .theme
                            //     .inputTextCursorColor,
                            decoration: InheritedChatTheme.of(context)
                                .theme
                                .inputTextDecoration
                                .copyWith(
                                  hintStyle: InheritedChatTheme.of(context)
                                      .theme
                                      .inputTextStyle
                                      .copyWith(
                                        color: Colors.black.withOpacity(0.24),
                                      ),
                                  hintText: "请输入消息...",
                                ),
                            focusNode: _inputFocusNode,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 1,
                            onChanged: widget.onTextChanged,
                            onTap: widget.onTextFieldTap,
                            style: InheritedChatTheme.of(context)
                                .theme
                                .inputTextStyle
                                .copyWith(
                                  color: Colors.black,
                                ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        Visibility(
                          visible: _sendButtonVisible,
                          child: Container(
                            height: 24,
                            margin: const EdgeInsets.only(left: 8),
                            width: 24,
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                                // color: InheritedChatTheme.of(context)
                                //     .theme
                                //     .inputTextColor,
                              ),
                              onPressed: _handleSendPressed,
                              padding: EdgeInsets.zero,
                              tooltip: InheritedL10n.of(context)
                                  .l10n
                                  .sendButtonAccessibilityLabel,
                            ),
                          ),
                        ),
                        Visibility(
                            visible: !_sendButtonVisible,
                            child: _rightWidget()),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}