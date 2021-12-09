import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ImageMessage;
import '../controllers/room_controller.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import './image_message.dart';

class RoomView extends GetView<RoomController> {
  @override
  Widget build(BuildContext context) {
    final messageController = MessageController.to;
    final roomId = controller.roomId;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final room = messageController.entities[roomId];
          return room != null && room.isLoading
              ? Text("loading")
              : Text('ChatView');
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        final room = messageController.entities[roomId];
        final roomMessageIndexes =
            messageController.roomMessageIndexesMap[roomId];
        final List<types.Message> emptyMessages = [];
        final messages = roomMessageIndexes != null
            ? roomMessageIndexes
                .map<types.Message>(
                    (id) => messageController.messageEntities[id]!)
                .toList()
            : emptyMessages;
        // add preview
        if (controller.previewMessage != null) {
          messages.insert(0, controller.previewMessage!);
        }
        return Chat(
          usePreviewData: true,
          onPreviewDataFetched:
              (types.Message message, types.PreviewData previewData) {
            messageController.handlePreviewDataFetched(message.id, previewData);
          },
          messages: messages,
          imageMessageBuilder: (message, {required int messageWidth}) {
            return ImageMessage(message: message, messageWidth: messageWidth);
          },
          emptyState: room != null && room.isLoading
              ? Text("isLoading")
              : Text("No message yet"),
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
          user: controller.user!,
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

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }
}
