import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NextButton extends StatelessWidget {
  final String? text;
  final void Function() onPressed;
  final bool? confirm;
  final bool? disabled;
  NextButton(
      {Key? key,
      required this.onPressed,
      this.text,
      this.confirm = false,
      this.disabled = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(48),
          splashFactory: NoSplash.splashFactory),
      onPressed: disabled != null && disabled!
          ? null
          : () {
              handleNext(context);
            },
      child: Text(text == null ? 'Next'.tr : text!,
          style: TextStyle(fontSize: 16)),
    );
  }

  handleNext(BuildContext context) {
    if (confirm != null && confirm!) {
      Get.defaultDialog(
          title: "Tips".tr,
          content: Text(
            "Submit_confirm".tr,
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          confirmTextColor: Theme.of(context).colorScheme.onSurface,
          cancel: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                  child: Text("Cancel".tr),
                  onPressed: () {
                    Get.back();
                  })),
          confirm: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  child: Text("Confirm".tr),
                  onPressed: () {
                    Get.back();
                    onPressed();
                  })),
          titlePadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.all(20),
          radius: 10);
    } else {
      onPressed();
    }
  }
}
