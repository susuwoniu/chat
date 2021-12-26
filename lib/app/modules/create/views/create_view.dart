import 'package:chat/app/modules/post/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:text_editor/text_editor.dart';
import '../../post/controllers/post_controller.dart';
import 'package:chat/common.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/app/ui_utils/location.dart';
import '../controllers/create_controller.dart';
import 'package:location/location.dart';

class CreateView extends GetView<CreateController> {
  @override
  Widget build(BuildContext context) {
    final postTemplate =
        PostController.to.postTemplatesMap[controller.postTemplateId]!;
    final currentAccount = AuthProvider.to.account.value;
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
    TextAlign _textAlign = TextAlign.left;
    return Scaffold(
      appBar: AppBar(
        title: Text('创建帖子'),
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: Obx(() => ElevatedButton(
                  child: Text("发布"),
                  style: ButtonStyle(),
                  onPressed: controller.isComposing
                      ? () async {
                          _handleSubmitted();
                        }
                      : null,
                )),
          )
        ],
      ),
      body: SafeArea(
          child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Avatar(
                    name: currentAccount.name, uri: currentAccount.avatar)),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentAccount.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text("公开 "),
                        Icon(Icons.public, size: 16),
                      ],
                    )
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(children: [
                      Text("显示到附近"),
                      Obx(() => Switch(
                          value: ConfigProvider.to.listAtNearby,
                          onChanged: (value) async {
                            // check permission
                            await ConfigProvider.to.toggleListAtNearby();

                            try {
                              if (value == true) {
                                await checkLocationPermission();
                              }
                            } catch (e) {
                              UIUtils.showError(e);
                              // change back
                              await ConfigProvider.to.toggleListAtNearby();
                            }
                          })),
                    ]))
              ],
            ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
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
        ))
      ])),
    );
  }

  Future<void> _handleSubmitted() async {
    if (!controller.isComposing || controller.isSubmitting) {
      return;
    }
    controller.setIsSubmitting(true);

    try {
      // check permission
      LocationData? _locationData;
      if (ConfigProvider.to.listAtNearby) {
        try {
          _locationData = await getLocation();
        } catch (e) {
          // donothing
        }
      }

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
