import 'package:chat/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../edit_name/views/appbar_save.dart';
import '../controllers/edit_bio_controller.dart';
import '../../edit_name/views/input_widget.dart';
import 'package:chat/app/providers/providers.dart';

class EditBioView extends GetView<EditBioController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bio".tr, style: TextStyle(fontSize: 16)),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              preferredSize: Size.fromHeight(0)),
          actions: [
            Obx(() {
              final _isActived = controller.isActived.value;
              return AppBarSave(
                  isActived: _isActived,
                  onPressed: () async {
                    try {
                      await AccountProvider.to.postAccountInfoChange(
                        {"bio": controller.currentBio.value},
                      );
                      RouterProvider.to.toNextPage();
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  });
            }),
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Obx(() {
            return InputWidget(
                maxLength: MAX_BIO_LENGTH,
                maxLines: 10,
                minLines: 3,
                initialContent: controller.initialContent,
                onChange: controller.onChangeTextValue);
          }),
        ));
  }
}
