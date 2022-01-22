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
import '../../my_single_post/views/visibility_sheet.dart';

final VisibilityMap = {'public': 'Public', 'private': 'Private'};

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
      fontSize: 25,
      color: Colors.white,
    );
    String _text = postTemplate.content ?? '';
    TextAlign _textAlign = TextAlign.left;
    return Scaffold(
      appBar: AppBar(
          title: Text('Create'.tr),
          centerTitle: true,
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Colors.grey.shade400,
              ),
              preferredSize: Size.fromHeight(0)),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 16, top: 10, bottom: 10),
              child: Obx(() => ElevatedButton(
                    child: Text("Send".tr),
                    style: ButtonStyle(),
                    onPressed: controller.isComposing
                        ? () async {
                            _handleSubmitted();
                          }
                        : null,
                  )),
            )
          ]),
      body: SafeArea(
          child: Column(children: [
        SizedBox(height: 15),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(currentAccount.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                  ]),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return VisibilitySheet(
                                onPressedVisibility: (String visibility) {
                              controller.setIsVisibility(visibility);
                            });
                          });
                    },
                    child: Obx(() => Row(children: [
                          Text(VisibilityMap[controller.visibility]!.tr + ' ',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                          Icon(
                              controller.visibility == 'public'
                                  ? Icons.public
                                  : Icons.lock_outline_rounded,
                              size: 16,
                              color: Colors.black54),
                        ])),
                  )
                ]),
                Row(children: [
                  Text("Location".tr),
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
                ])
              ])),
        ]),
        SizedBox(
          height: 15,
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

      await controller.postAnswer(location: _locationData);
      controller.setIsSubmitting(false);

      UIUtils.hideLoading();
      UIUtils.toast("send_successfully".tr);
      RouterProvider.to.toHome();
      AuthProvider.to.account.update((value) {
        if (value != null) {
          value.is_can_post = false;
        }
      });
    } catch (e) {
      UIUtils.hideLoading();
      UIUtils.showError(e);
      controller.setIsSubmitting(false);
    }
  }
}
