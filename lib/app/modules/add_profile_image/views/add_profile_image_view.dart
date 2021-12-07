import 'package:chat/app/modules/login/controllers/login_controller.dart';
import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:get/get.dart';

import '../controllers/add_profile_image_controller.dart';
import '../../age_picker/views/next_button.dart';

class AddProfileImageView extends GetView<AddProfileImageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddProfileImageView'),
        centerTitle: true,
      ),
      body: Column(children: [
        Text(
          'AddProfileImageView is working',
          style: TextStyle(fontSize: 20),
        ),
        NextButton(
          onPressed: () async {
            try {
              await LoginController.to
                  .postAccountInfoChange({'skip_optional_info': true});
            } catch (e) {
              UIUtils.showError(e);
            }
          },
        ),
      ]),
    );
  }
}
