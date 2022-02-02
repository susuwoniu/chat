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
        appBar: roomAppBar(context: context, roomId: roomId),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          Flexible(
            child: Obx(() {
              final room = messageController.entities[roomId];

              if (room == null || room.isLoading || !room.isInitDbMessages) {
                return Center(
                  child: CircularProgressIndicator(),
                );
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

              return Chat(
                isLastPage: room.isLastPage,
                messages: messages,
                bubbleBuilder: (
                  Widget child, {
                  required types.Message message,
                  required bool nextMessageInGroup,
                }) {
                  return BubbleWidget(child,
                      message: message, nextMessageInGroup: nextMessageInGroup);
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
                    sendButtonVisibilityMode: SendButtonVisibilityMode.editing),
                textMessageBuilder: (
                  types.TextMessage message, {
                  required int messageWidth,
                  required bool showName,
                }) {
                  return TextMessage(
                    message: message,
                    showName: showName,
                    usePreviewData: false,
                    emojiEnlargementBehavior: EmojiEnlargementBehavior.multi,
                    hideBackgroundOnEmojiMessages: true,
                    onPreviewDataFetched:
                        (types.Message message, types.PreviewData previewData) {
                      messageController.handlePreviewDataFetched(
                          message.id, previewData);
                    },
                  );
                },
                imageMessageBuilder: (message, {required int messageWidth}) {
                  return ImageMessage(
                      message: message, messageWidth: messageWidth);
                },
                emptyState: ((room.isLoading))
                    ? Center(child: Loading())
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
              );
            }),
          )
        ]));
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
              ],
            ),
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

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handleMessageStatusTap(types.Message message) async {
    if (message.status == types.Status.error) {
      // retry message
      // await MessageController.to.cancelMessage(message);
      await MessageController.to.resendMessage(controller.roomId, message);
    }
  }

  PreferredSizeWidget roomAppBar(
      {required BuildContext context, required String roomId}) {
    final _width = MediaQuery.of(context).size.width;

    return AppBar(
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
                        uri: roomAccount?.avatar,
                        name: roomAccount?.name ?? jidToName(room!.id),
                        onTap: () {
                          if (roomInfoId == AuthProvider.to.accountId) {
                            RouterProvider.to.toMe();
                            return;
                          }
                          Get.toNamed(Routes.OTHER,
                              arguments: {"accountId": roomInfoId});
                        }),
                  ),
                  SizedBox(width: 10),
                  room != null && room.isLoading
                      ? Text("Loading".tr, style: TextStyle(fontSize: 16))
                      : Container(
                          width: _width * 0.45,
                          child: Flexible(
                              child: Text(
                                  roomAccount?.name ?? jidToName(room!.id),
                                  style: TextStyle(fontSize: 16)))),
                ]),
                LikeCount(
                  count: roomAccount?.like_count != null
                      ? roomAccount!.like_count
                      : 0,
                  backgroundColor: Colors.transparent,
                ),
              ]);
        }),
        bottom: PreferredSize(
            child: Container(
              height: 0.5,
              color: Colors.grey.shade400,
            ),
            preferredSize: Size.fromHeight(0)));
  }
}
