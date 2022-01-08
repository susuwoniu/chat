import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/providers/chat_provider/chat_provider.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:chat/common.dart';
=======
>>>>>>> 7e80854bfcd15af618ced8cedda162c3cb508cae
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart'
    hide ImageMessage, TextMessage;
import '../controllers/room_controller.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import './image_message.dart';
import './text_message.dart';
import './bottom_widget.dart';
import './bubble_widget.dart';
import '../../message/views/appbar_border.dart';

class RoomView extends GetView<RoomController> {
  @override
  Widget build(BuildContext context) {
    final messageController = MessageController.to;
    final roomId = controller.roomId;
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: AppbarBorder(), preferredSize: Size.fromHeight(0)),
        title: Obx(() {
          final roomInfoId = messageController.entities[roomId]!.room_info_id;
          final room = messageController.entities[roomId];
          final roomAccount = roomInfoId != null
              ? AuthProvider.to.simpleAccountMap[roomInfoId]
              : null;
          return room != null && room.isLoading
              ? Text("Loading")
              : Text(roomAccount?.name ?? "Room");
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        final room = messageController.entities[roomId];

        if (room == null || room.isLoading || !room.isInitServerMessages) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final roomInfoId = messageController.entities[roomId]!.room_info_id;
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
          messages: messages,
          bubbleBuilder: (
            Widget child, {
            required types.Message message,
            required bool nextMessageInGroup,
          }) {
            return BubbleWidget(child,
                message: message, nextMessageInGroup: nextMessageInGroup);
          },
          customBottomWidget: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    )
                  ],
                  border: Border(
                      top: BorderSide(
                    color: Colors.grey.shade200,
                  ))),
              child: BottomWidget(
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
                  sendButtonVisibilityMode: SendButtonVisibilityMode.editing)),
          textMessageBuilder: (
            types.TextMessage message, {
            required int messageWidth,
            required bool showName,
          }) {
            return TextMessage(
              message: message,
              showName: showName,
              usePreviewData: true,
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
            return ImageMessage(message: message, messageWidth: messageWidth);
          },
          emptyState:
              ((room.isLoading)) ? Center(child: Loading()) : SizedBox.shrink(),
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
          onEndReached: controller.handleEndReached,
          user: ChatProvider.to.currentChatAccount.value!,
        );
      }),
    );
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
}
