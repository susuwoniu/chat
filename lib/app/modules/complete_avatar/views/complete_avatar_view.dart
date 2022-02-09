import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:chat/common.dart';
import 'package:get/get.dart';

import '../controllers/complete_avatar_controller.dart';
import '../../complete_age/views/next_button.dart';

class CompleteAvatarView extends GetView<CompleteAvatarController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CompleteAvatarView', style: TextStyle(fontSize: 16)),
      ),
      body: Column(children: [
        Text(
          'CompleteAvatarView is working',
          style: TextStyle(fontSize: 20),
        ),
        NextButton(
          onPressed: () async {
            try {
              final account = await AccountProvider.to
                  .postAccountInfoChange({'skip_optional_info': true});
              // if next action to next action
              AuthProvider.to.checkActions(account.actions);
            } catch (e) {
              UIUtils.showError(e);
            }
          },
        ),
      ]),
    );
  }
}
