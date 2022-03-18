import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:in_app_review/in_app_review.dart';

class LogonWidget extends AbstractSettingsSection {
  final InAppReview inAppReview = InAppReview.instance;

  LogonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 10),
      Image(
        image: AssetImage('assets/f.png'),
        width: 50,
      ),
      SizedBox(height: 14),
      Text(
        'old_school'.tr,
        style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 7),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('ver'.tr, style: TextStyle(color: Colors.grey.shade500)),
        SizedBox(width: 5),
        Text('1.0', style: TextStyle(color: Colors.grey.shade500)),
      ]),
      SizedBox(height: 50)
    ]);
  }
}
