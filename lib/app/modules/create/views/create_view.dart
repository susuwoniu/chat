import 'package:chat/app/modules/post/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:text_editor/text_editor.dart';
import '../../post/controllers/post_controller.dart';
import 'package:chat/common.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';

import '../controllers/create_controller.dart';

class CreateView extends GetView<CreateController> {
  @override
  Widget build(BuildContext context) {
    final postTemplate =
        PostController.to.postTemplatesMap[controller.postTemplateId]!;
    final fonts = [
      'OpenSans',
      'Billabong',
      'GrandHotel',
      'Oswald',
      'Quicksand',
      'BeautifulPeople',
      'BeautyMountains',
      'BiteChocolate',
      'BlackberryJam',
      'BunchBlossoms',
      'CinderelaRegular',
      'Countryside',
      'Halimun',
      'LemonJelly',
      'QuiteMagicalRegular',
      'Tomatoes',
      'TropicalAsianDemoRegular',
      'VeganStyle',
    ];
    TextStyle _textStyle = TextStyle(
      fontSize: 30,
      color: Colors.white,
    );
    String _text = postTemplate.content;
    TextAlign _textAlign = TextAlign.center;
    return Scaffold(
      appBar: AppBar(
        title: Text('CreateView'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              _handleSubmitted();
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
              child: TextEditor(
        fonts: fonts,
        text: controller.postTemplateFormattedText,
        hintText: _text,
        defaultTextPosition: controller.defaultTextPosition,
        textStyle: _textStyle,
        textAlingment: _textAlign,
        minFontSize: 10,
        onChange: controller.handleChange,
        backgroundColorPaletteColors: BACKGROUND_COLORS,
        paletteColors:
            List.generate(BACKGROUND_COLORS.length, (index) => Colors.white),
        defaultBackgroundColorIndex: controller.backgroundColorIndex,
        // decoration: EditorDecoration(
        //   textBackground: TextBackgroundDecoration(
        //     disable: Text('Disable'),
        //     enable: Text('Enable'),
        //   ),
        //   doneButton: Icon(Icons.close, color: Colors.white),
        //   fontFamily: Icon(Icons.title, color: Colors.white),
        //   colorPalette: Icon(Icons.palette, color: Colors.white),
        //   alignment: AlignmentDecoration(
        //     left: Text(
        //       'left',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     center: Text(
        //       'center',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     right: Text(
        //       'right',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        // ),
      ))),
    );
  }

  Future<void> _handleSubmitted() async {
    if (!controller.isComposing || controller.isSubmitting) {
      return;
    }
    controller.setIsSubmitting(true);

    try {
      UIUtils.showLoading();

      await controller.postAnswer();
      controller.setIsSubmitting(false);

      UIUtils.hideLoading();
      UIUtils.toast("send_successfully".tr);
      RouterProvider.to.toHome();
    } catch (e) {
      UIUtils.hideLoading();
      UIUtils.showError(e);
      controller.setIsSubmitting(false);
    }
  }
}
