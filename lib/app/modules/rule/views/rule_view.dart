import 'package:flutter/material.dart';
import 'package:chat/app/common/link.dart';

import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../age_picker/views/next_button.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/common.dart';
import '../controllers/rule_controller.dart';

class RuleView extends GetView<RuleController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text('社区规则'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Markdown(
                shrinkWrap: true,
                data: controller.content,
                onTapLink: (href, _, __) async {
                  await openLink(href);
                },
              ),
              NextButton(
                  text: 'I_agree_rules'.tr,
                  onPressed: () async {
                    try {
                      final account = await AccountProvider.to
                          .postAccountInfoChange(
                              {"agree_community_rules": true});

                      // if next action to next action
                      AuthProvider.to.checkActions(account.actions);
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  }),
              SizedBox(height: 10),
              TextButton(
                  child: Text('退出'),
                  onPressed: () async {
                    await AccountProvider.to.handleLogout();
                    await RouterProvider.to.restart(context);
                  })
            ],
          ),
        ));
  }
}
