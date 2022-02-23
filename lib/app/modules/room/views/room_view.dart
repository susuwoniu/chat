import 'package:chat/app/modules/other/controllers/other_controller.dart';
import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart'
    hide ImageMessage, TextMessage;
import '../controllers/room_controller.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import './image_message.dart';
import './text_message.dart';
import './bottom_widget.dart';
import './bubble_widget.dart';
import '../../me/views/like_count.dart';

class RoomView extends GetView<RoomController> {
  @override
  Widget build(BuildContext context) {
    final messageController = MessageController.to;
    final roomId = controller.roomId;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: roomAppBar(
          context: context,
          roomId: roomId,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Flexible(
              child: Obx(() {
                final room = messageController.entities[roomId];

                if (room == null || room.isLoading || !room.isInitDbMessages) {
                  return Container(
                      color: Theme.of(context).colorScheme.background,
                      child: Loading());
                }
                final roomInfoId =
                    messageController.entities[roomId]!.room_info_id;
                final toAccount = roomInfoId != null
                    ? AuthProvider.to.simpleAccountMap[roomInfoId]
                    : null;
                final roomMessageIndexes =
                    messageController.roomMessageIndexesMap[roomId];

                final List<types.Message> emptyMessages = [];
                final messages = roomMessageIndexes != null
                    ? roomMessageIndexes
                        .map<types.Message>(
                            (id) => messageController.messageEntities[id]!)
                        .toList()
                    : emptyMessages;
                final _query = MediaQuery.of(context);

                return AnimatedPadding(
                    padding: EdgeInsets.only(
                        bottom: _query.viewInsets.bottom +
                            _query.padding.bottom +
                            12),
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOut,
                    child: Chat(
                      theme: Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? DefaultChatTheme(
                              primaryColor: Theme.of(context).primaryColor,
                              messageInsetsVertical: 12,
                              messageInsetsHorizontal: 14,
                              receivedMessageBodyTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ))
                          : DarkChatTheme(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              primaryColor: Theme.of(context).primaryColor,
                              secondaryColor:
                                  Theme.of(context).colorScheme.background,
                              receivedMessageBodyTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              )),
                      isLastPage: room.isLastPage,
                      messages: messages,
                      bubbleBuilder: (
                        Widget child, {
                        required types.Message message,
                        required bool nextMessageInGroup,
                      }) {
                        return BubbleWidget(child,
                            message: message,
                            nextMessageInGroup: nextMessageInGroup);
                      },
                      customBottomWidget: BottomWidget(
                          onCancelQuote: controller.handleCancelPreview,
                          quoteMessage: controller.previewMessage,
                          replyTo: controller.previewMessage != null
                              ? toAccount?.name
                              : null,
                          onAttachmentPressed: () {
                            _handleImageSelection();
                          },
                          onCameraPressed: () {
                            _handleCameraSelection();
                          },
                          onSendPressed: (types.PartialText message) async {
                            try {
                              await controller.handleSendPressed(message);
                            } catch (e) {
                              UIUtils.showError(e);
                            }
                          },
                          sendButtonVisibilityMode:
                              SendButtonVisibilityMode.editing),
                      textMessageBuilder: (
                        types.TextMessage message, {
                        required int messageWidth,
                        required bool showName,
                      }) {
                        return TextMessage(
                          message: message,
                          showName: showName,
                          usePreviewData: false,
                          emojiEnlargementBehavior:
                              EmojiEnlargementBehavior.multi,
                          hideBackgroundOnEmojiMessages: true,
                          onPreviewDataFetched: (types.Message message,
                              types.PreviewData previewData) {
                            messageController.handlePreviewDataFetched(
                                message.id, previewData);
                          },
                        );
                      },
                      imageMessageBuilder: (message,
                          {required int messageWidth}) {
                        return ImageMessage(
                            message: message, messageWidth: messageWidth);
                      },
                      emptyState: ((room.isLoading))
                          ? Container(
                              color: Theme.of(context).colorScheme.background,
                              child: Loading())
                          : SizedBox.shrink(),
                      onAttachmentPressed: () {
                        _handleAtachmentPressed(context);
                      },
                      onSendPressed: (types.PartialText message) async {
                        try {
                          await controller.handleSendPressed(message);
                        } catch (e) {
                          UIUtils.showError(e);
                        }
                      },
                      onMessageTap: _handleMessageTap,
                      onMessageStatusTap: _handleMessageStatusTap,
                      onEndReached: controller.handleEndReached,
                      user: ChatProvider.to.currentChatAccount.value!,
                    ));
              }),
            )
          ]),
        ));
  }

  void _handleAtachmentPressed(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleImageSelection();
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Photo'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleFileSelection();
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('File'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Cancel'),
                    ),
                  ),
                ]),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final messageController = MessageController.to;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        await messageController.sendFileMessage(controller.roomId, result);
      }
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  void _handleImageSelection() async {
    final messageController = MessageController.to;

    try {
      final result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.gallery,
      );

      if (result != null) {
        await messageController.sendImageMessage(controller.roomId, result);
      }
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  void _handleCameraSelection() async {
    final messageController = MessageController.to;

    try {
      final result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.camera,
      );

      if (result != null) {
        await messageController.sendImageMessage(controller.roomId, result);
      }
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri, type: message.mimeType);
    }
  }

  void _handleMessageStatusTap(
      BuildContext context, types.Message message) async {
    if (message.status == types.Status.error) {
      // retry message
      // await MessageController.to.cancelMessage(message);
      await MessageController.to.resendMessage(controller.roomId, message);
    }
  }

  AppBar roomAppBar({required BuildContext context, required String roomId}) {
    final _width = MediaQuery.of(context).size.width;
    final _controller = OtherController.to;

    return AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Obx(() {
          final roomInfoId =
              MessageController.to.entities[roomId]!.room_info_id;
          final room = MessageController.to.entities[roomId];
          final roomAccount = roomInfoId != null
              ? AuthProvider.to.simpleAccountMap[roomInfoId]
              : null;
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Avatar(
                        elevation: 0,
                        size: 20,
                        uri: roomAccount?.avatar?.thumbnail.url,
                        name: roomAccount?.name ?? jidToName(room!.id),
                        onTap: () {
                          if (roomInfoId == AuthProvider.to.accountId) {
                            RouterProvider.to.toMe();
                            return;
                          }
                          Get.toNamed(Routes.OTHER,
                              arguments: {"id": roomInfoId});
                        }),
                  ),
                  SizedBox(width: 10),
                  room != null && room.isLoading
                      ? Text("Loading".tr, style: TextStyle(fontSize: 16))
                      : Container(
                          width: _width * 0.45,
                          child: Text(roomAccount?.name ?? jidToName(room!.id),
                              style: TextStyle(fontSize: 16))),
                ]),
                LikeCount(
                  count: roomAccount?.like_count != null
                      ? roomAccount!.like_count
                      : 0,
                  backgroundColor: Colors.transparent,
                  onTap: () async {
                    _controller.accountAction(increase: !roomAccount!.is_liked);
                    if (!roomAccount.is_liked) {
                      try {
                        await _controller.postLikeCount(roomInfoId!);
                        UIUtils.toast('Liked!'.tr);
                        final currentAccount =
                            AuthProvider.to.simpleAccountMap[roomInfoId]!;
                        currentAccount.like_count += 1;
                        AuthProvider.to.simpleAccountMap[roomInfoId] =
                            currentAccount;
                      } catch (e) {
                        UIUtils.showError(e);
                        _controller.accountAction(increase: false);
                      }
                    } else {
                      try {
                        await _controller.cancelLikeCount(roomInfoId!);
                        UIUtils.toast('Successfully_unliked.'.tr);
                        final currentAccount =
                            AuthProvider.to.simpleAccountMap[roomInfoId]!;
                        currentAccount.like_count -= 1;
                        AuthProvider.to.simpleAccountMap[roomInfoId] =
                            currentAccount;
                      } catch (e) {
                        UIUtils.showError(e);
                        _controller.accountAction(increase: true);
                      }
                    }
                  },
                ),
              ]);
        }),
        bottom: PreferredSize(
            child: Container(
              height: 0.5,
              color: Theme.of(context).dividerColor,
            ),
            preferredSize: Size.fromHeight(0)));
  }
}
